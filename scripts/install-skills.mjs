#!/usr/bin/env node
import { existsSync, lstatSync, mkdirSync, readFileSync, realpathSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
import { join, resolve } from 'node:path';
import { homedir } from 'node:os';
import { fileURLToPath } from 'node:url';
import { detectAgents, getSupportedAgents, installSkills } from 'skills';
import { linkWithBackup } from './file-links.mjs';
import { restoreGroups, validateSkillName } from './skills-plan.mjs';
import { discoverPersonalSkills, removeBlacklistedLinks, validateBlacklist } from './personal-skills.mjs';

const root = fileURLToPath(new URL('../', import.meta.url));
const home = homedir();
const dryRun = process.argv.includes('--dry-run');
if (process.argv.slice(2).some((arg) => arg !== '--dry-run')) throw new Error('Usage: node scripts/install-skills.mjs [--dry-run]');
const lock = JSON.parse(readFileSync(join(root, 'config/skills/skill-lock.json'), 'utf8'));
const personal = JSON.parse(readFileSync(join(root, 'config/skills/personal.json'), 'utf8'));
const canonical = join(home, '.agents/skills');
const checkout = resolve(personal.directory.replace(/^~(?=\/|$)/, home));
validateBlacklist(personal.blacklist);
let personalSkills = existsSync(checkout) ? discoverPersonalSkills(checkout, personal.blacklist) : [];
const detected = new Set((await detectAgents({ cwd: root })).agents.map((agent) => agent.id));
const supported = getSupportedAgents();
const requested = lock.lastSelectedAgents || ['codex', 'claude-code'];
const agents = supported.filter((agent) => requested.includes(agent.id) && detected.has(agent.id));
if (!agents.length) agents.push(supported.find((agent) => agent.id === 'codex'));
const destinations = [...new Set([canonical, ...agents.map((agent) => agent.globalSkillsDir).filter(Boolean)])];
const installed = new Set(Object.keys(lock.skills).filter((name) => existsSync(join(canonical, validateSkillName(name), 'SKILL.md'))));
const groups = restoreGroups(lock, installed);
const backup = join(home, '.local/state/dotfiles/backups', `skills-${new Date().toISOString().replaceAll(':', '-')}`);

console.log(`Skills: keep ${installed.size} installed; restore ${groups.reduce((n, group) => n + group.skills.length, 0)} missing.`);
console.log(`Personal checkout: ${checkout}; ${existsSync(checkout) ? personalSkills.length : 'not yet discovered'} personal skills.`);
console.log(`Personal blacklist: ${personal.blacklist.join(', ') || '(empty)'}`);
console.log(`Agent targets: ${agents.map((agent) => agent.id).join(', ')}`);
if (dryRun) {
	for (const group of groups) console.log(`Would install ${group.skills.join(', ')} from ${group.source}`);
	console.log(existsSync(checkout) ? 'Existing checkout will be kept without pulling.' : `Would clone ${personal.repository}`);
	if (personalSkills.length) console.log(`Would link personal skills: ${personalSkills.join(', ')}`);
	process.exit(0);
}

if (!existsSync(checkout)) {
	mkdirSync(resolve(checkout, '..'), { recursive: true });
	execFileSync('git', ['clone', '--', personal.repository, checkout], { stdio: 'inherit' });
	personalSkills = discoverPersonalSkills(checkout, personal.blacklist);
}
// Two sources must not compete for the same canonical directory.
for (const name of personalSkills) {
	if (Object.hasOwn(lock.skills, name)) throw new Error(`Personal skill ${name} is also recorded in the skills.sh lock. Blacklist it here or remove the remote entry before installing.`);
}
const failures = [];
for (const group of groups) {
	console.log(`Installing ${group.skills.join(', ')} from ${group.source}`);
	try {
		const result = await installSkills(group.source, {
		cwd: root, scope: 'global', mode: 'symlink', skills: group.skills,
		agents: agents.map((agent) => agent.id), ref: group.ref,
		lockfile: false, telemetry: false,
		});
		if (result.failed.length) failures.push(...result.failed.map((failure) => failure.message));
	} catch (error) {
		failures.push(`${group.skills.join(', ')}: ${error.message}`);
	}
}
for (const name of Object.keys(lock.skills)) if (!existsSync(join(canonical, name, 'SKILL.md'))) failures.push(`Skill was not restored: ${name}`);
const removed = removeBlacklistedLinks(checkout, personal.blacklist, destinations, canonical);
for (const name of personalSkills) linkWithBackup(join(checkout, name), join(canonical, name), home, backup);
let keptCopies = 0;
for (const name of new Set([...Object.keys(lock.skills), ...personalSkills])) {
	const source = join(canonical, name);
	if (!existsSync(join(source, 'SKILL.md'))) continue;
	for (const directory of destinations) {
		const target = join(directory, name);
		if (resolve(target) === resolve(source)) continue;
		if (existsSync(target) && realpathSync(target) === realpathSync(source)) continue;
		// Existing independent copies may contain edits; leave them for review.
		if (existsSync(target) && !lstatSync(target).isSymbolicLink() && !personalSkills.includes(name)) {
			keptCopies++;
			continue;
		}
		linkWithBackup(source, target, home, backup);
	}
}
console.log(`Skills restored and linked. Preserved ${keptCopies} independent agent copies; originals replaced by links are backed up under ${backup}.`);
if (removed.length) console.log(`Removed ${removed.length} blacklisted personal skill links; source folders were kept.`);
if (failures.length) {
	console.error(`Unresolved skills:\n${[...new Set(failures)].join('\n')}`);
	process.exitCode = 1;
}
