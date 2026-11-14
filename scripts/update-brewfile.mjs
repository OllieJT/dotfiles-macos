#!/usr/bin/env node

import { execFileSync } from 'node:child_process';
import { readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath, pathToFileURL } from 'node:url';

export function parseBlacklist(contents) {
	const ids = new Set();
	for (const [index, line] of contents.split(/\r?\n/).entries()) {
		const id = line.split('#', 1)[0].trim();
		if (!id) continue;
		if (!/^[1-9]\d*$/.test(id)) {
			throw new Error(`Invalid App Store ID on blacklist line ${index + 1}: ${id}`);
		}
		ids.add(id);
	}
	return ids;
}

export function filterBrewfile(contents, blacklist) {
	return contents.split('\n').filter((line) => {
		const entry = line.match(/^mas\s+"(?:[^"\\]|\\.)*",\s*id:\s*(\d+)\b/);
		return !entry || !blacklist.has(entry[1]);
	}).join('\n');
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
	const root = new URL('../', import.meta.url);
	const blacklist = parseBlacklist(readFileSync(new URL('config/homebrew/mas-blacklist.txt', root), 'utf8'));
	const snapshot = execFileSync('brew', ['bundle', 'dump', '--file=-'], {
		cwd: fileURLToPath(root),
		encoding: 'utf8',
		maxBuffer: 16 * 1024 * 1024,
		stdio: ['ignore', 'pipe', 'inherit'],
	});
	writeFileSync(new URL('Brewfile', root), filterBrewfile(snapshot, blacklist));
	console.log('Brewfile updated; App Store blacklist applied ✅');
}
