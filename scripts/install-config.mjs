#!/usr/bin/env node
import { existsSync, mkdirSync, readFileSync, writeFileSync, chmodSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { homedir } from 'node:os';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { parse, stringify } from 'smol-toml';
import { mergeConfig, privateOverlay, privateNpmrc } from './config-model.mjs';
import { homePath, linkWithBackup } from './file-links.mjs';

export function installConfig(root, home = homedir()) {
	const entries = JSON.parse(readFileSync(join(root, 'config/files.json'), 'utf8'));
	const state = join(home, '.local/state/dotfiles');
	mkdirSync(state, { recursive: true, mode: 0o700 });
	chmodSync(state, 0o700);
	const backup = join(state, 'backups', new Date().toISOString().replaceAll(':', '-'));
	// Prepare all content before replacing any live path.
	const prepared = entries.map((entry) => {
		const target = homePath(home, entry.target);
		const source = join(root, entry.source);
		const sharedText = readFileSync(source, 'utf8');
		if (!entry.format) return { source, target };
		const localFile = join(state, 'private', `${entry.target}.json`);
		const currentText = existsSync(target) ? readFileSync(target, 'utf8') : null;
		let local, output;
		if (entry.format === 'lines') {
			const sharedLines = new Set(sharedText.split('\n').map((line) => line.trim()).filter(Boolean));
			local = currentText !== null ? currentText.split('\n').filter((line) => line.trim() && !sharedLines.has(line.trim())).join('\n')
				: existsSync(localFile) ? JSON.parse(readFileSync(localFile, 'utf8')) : '';
			output = `${sharedText.trim()}\n${local ? `${local}\n` : ''}`;
		} else if (entry.format === 'npmrc') {
			local = currentText !== null ? privateNpmrc(currentText, sharedText)
				: existsSync(localFile) ? JSON.parse(readFileSync(localFile, 'utf8')) : '';
			output = `${sharedText.trim()}\n${local ? `${local}\n` : ''}`;
		} else {
			const decode = entry.format === 'toml' ? parse : JSON.parse;
			const shared = decode(sharedText);
			local = currentText !== null ? privateOverlay(decode(currentText), shared)
				: existsSync(localFile) ? JSON.parse(readFileSync(localFile, 'utf8')) : {};
			const merged = mergeConfig(shared, local);
			for (const [key, identityField] of Object.entries(entry.requiresLocal || {})) {
				if (!local[key]?.[identityField]) delete merged[key];
			}
			output = entry.format === 'toml' ? stringify(merged) : `${JSON.stringify(merged, null, 2)}\n`;
		}
		return { source: join(state, 'generated', entry.target), target, localFile, local, output };
	});
	for (const entry of prepared) {
		if (entry.localFile) {
			for (const [file, contents] of [[entry.localFile, `${JSON.stringify(entry.local, null, 2)}\n`], [entry.source, entry.output]]) {
				mkdirSync(dirname(file), { recursive: true, mode: 0o700 });
				writeFileSync(file, contents, { mode: 0o600 });
				chmodSync(file, 0o600);
			}
		}
		linkWithBackup(entry.source, entry.target, home, backup);
	}
	console.log(`Linked ${prepared.length} configuration files. Originals, if replaced: ${backup}`);
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
	installConfig(fileURLToPath(new URL('../', import.meta.url)));
}
