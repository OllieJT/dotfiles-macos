import { existsSync, lstatSync, mkdirSync, readlinkSync, renameSync, symlinkSync } from 'node:fs';
import { dirname, isAbsolute, relative, resolve } from 'node:path';

export function homePath(home, target) {
	if (isAbsolute(target) || target.split(/[\\/]/).includes('..')) throw new Error(`Target must stay inside home: ${target}`);
	return resolve(home, target);
}

export function linkWithBackup(source, target, home, backupRoot) {
	let stat;
	try { stat = lstatSync(target); } catch (error) { if (error.code !== 'ENOENT') throw error; }
	if (stat?.isSymbolicLink() && resolve(dirname(target), readlinkSync(target)) === resolve(source)) return false;
	if (stat) {
		const backup = resolve(backupRoot, relative(home, target));
		if (existsSync(backup)) throw new Error(`Backup already exists: ${backup}`);
		mkdirSync(dirname(backup), { recursive: true, mode: 0o700 });
		renameSync(target, backup);
	}
	mkdirSync(dirname(target), { recursive: true });
	symlinkSync(source, target);
	return true;
}
