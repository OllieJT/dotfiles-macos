import { existsSync, lstatSync, readdirSync, readlinkSync, statSync, unlinkSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { validateSkillName } from './skills-plan.mjs';

export function validateBlacklist(blacklist) {
	if (!Array.isArray(blacklist) || blacklist.some((name) => typeof name !== 'string' || !name || name === '.' || name === '..' || /[\\/]/.test(name))) {
		throw new Error('Personal skill blacklist must contain folder names, not paths.');
	}
}

export function discoverPersonalSkills(checkout, blacklist) {
	validateBlacklist(blacklist);
	const ignored = new Set(blacklist);
	return readdirSync(checkout, { withFileTypes: true })
		.filter((entry) => entry.isDirectory() && !entry.name.startsWith('.') && !ignored.has(entry.name))
		.filter((entry) => {
			const marker = join(checkout, entry.name, 'SKILL.md');
			return existsSync(marker) && statSync(marker).isFile();
		})
		.map((entry) => validateSkillName(entry.name))
		.sort();
}

// Remove only symlinks created for this checkout, including links via canonical.
export function removeBlacklistedLinks(checkout, blacklist, destinations, canonical) {
	validateBlacklist(blacklist);
	const removed = [];
	for (const name of blacklist) {
		const canonicalTarget = join(canonical, name);
		let canonicalIsPersonal = false;
		try {
			canonicalIsPersonal = lstatSync(canonicalTarget).isSymbolicLink()
				&& resolve(dirname(canonicalTarget), readlinkSync(canonicalTarget)) === resolve(checkout, name);
		} catch (error) { if (error.code !== 'ENOENT') throw error; }
		for (const directory of destinations) {
			const target = join(directory, name);
			let stat;
			try { stat = lstatSync(target); } catch (error) { if (error.code === 'ENOENT') continue; throw error; }
			if (!stat.isSymbolicLink()) continue;
			const source = resolve(dirname(target), readlinkSync(target));
			if (source !== resolve(checkout, name) && !(canonicalIsPersonal && directory !== canonical && source === resolve(canonical, name))) continue;
			unlinkSync(target);
			removed.push(target);
		}
	}
	return removed;
}

// Fast-forward only: a checkout that is detached, untracked or diverged keeps its local history.
export function syncPlan({ branch, upstream, ahead, behind }) {
	if (!branch) return { action: 'skip', reason: 'detached HEAD' };
	if (!upstream) return { action: 'skip', reason: `${branch} has no upstream` };
	if (ahead && behind) return { action: 'skip', reason: `${branch} has diverged from ${upstream}` };
	return { action: behind ? 'pull' : 'none' };
}

// Skills with uncommitted or untracked files, from `git status --porcelain=v1 -z`.
export function unsharedSkills(porcelain, skills) {
	const names = new Set(skills);
	const found = new Set();
	const entries = porcelain.split('\0');
	for (let i = 0; i < entries.length; i++) {
		const entry = entries[i];
		if (!entry) continue;
		if (/^[RC]/.test(entry)) i++; // Renames and copies carry their source path as the next entry.
		const name = entry.slice(3).split('/')[0];
		if (names.has(name)) found.add(name);
	}
	return [...found].sort();
}
