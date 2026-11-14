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

export function parseRequiredCasks(contents) {
	return new Set(contents.split(/\r?\n/).flatMap((line, index) => {
		const cask = line.split('#', 1)[0].trim();
		if (!cask) return [];
		if (!/^[a-z0-9][a-z0-9@+._/-]*$/.test(cask)) {
			throw new Error(`Invalid required cask on line ${index + 1}: ${cask}`);
		}
		return [cask];
	}));
}

export function includeRequiredCasks(contents, requiredCasks) {
	const recorded = new Set([...contents.matchAll(/^cask "([^"]+)"/gm)].map((match) => match[1]));
	const missing = [...requiredCasks].filter((cask) => !recorded.has(cask));
	if (!missing.length) return contents;
	return `${contents.trimEnd()}\n\n# Additional apps to install\n${missing.map((cask) => `cask "${cask}"`).join('\n')}\n`;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
	const root = new URL('../', import.meta.url);
	const blacklist = parseBlacklist(readFileSync(new URL('config/homebrew/mas-blacklist.txt', root), 'utf8'));
	const requiredCasks = parseRequiredCasks(readFileSync(new URL('config/homebrew/required-casks.txt', root), 'utf8'));
	const snapshot = execFileSync('brew', ['bundle', 'dump', '--file=-'], {
		cwd: fileURLToPath(root),
		encoding: 'utf8',
		maxBuffer: 16 * 1024 * 1024,
		stdio: ['ignore', 'pipe', 'inherit'],
	});
	writeFileSync(new URL('Brewfile', root), includeRequiredCasks(filterBrewfile(snapshot, blacklist), requiredCasks));
	console.log('Brewfile updated; App Store blacklist applied ✅');
}
