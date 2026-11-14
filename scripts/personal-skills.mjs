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
