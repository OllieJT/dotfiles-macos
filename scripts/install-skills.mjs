#!/usr/bin/env node
import { existsSync, lstatSync, mkdirSync, readFileSync, realpathSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
import { join, resolve } from 'node:path';
import { homedir } from 'node:os';
import { fileURLToPath } from 'node:url';
import { detectAgents, getSupportedAgents, installSkills } from 'skills';
import { linkWithBackup } from './file-links.mjs';
import { restoreGroups, validateSkillName } from './skills-plan.mjs';
import { discoverPersonalSkills, removeBlacklistedLinks, syncPlan, unsharedSkills, validateBlacklist } from './personal-skills.mjs';

const root = fileURLToPath(new URL('../', import.meta.url));
const home = homedir();
const dryRun = process.argv.includes('--dry-run');
if (process.argv.slice(2).some((arg) => arg !== '--dry-run')) throw new Error('Usage: node scripts/install-skills.mjs [--dry-run]');
const lock = JSON.parse(readFileSync(join(root, 'config/skills/skill-lock.json'), 'utf8'));
const personal = JSON.parse(readFileSync(join(root, 'config/skills/personal.json'), 'utf8'));
const canonical = join(home, '.agents/skills');
const checkout = resolve(personal.directory.replace(/^~(?=\/|$)/, home));
validateBlacklist(personal.blacklist);
const git = (...args) => execFileSync('git', ['-C', checkout, ...args], { encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] }).trim();
const tryGit = (...args) => { try { return git(...args); } catch { return ''; } };
const gitError = (error) => error.stderr?.toString().trim() || error.message;
const warnings = [];
function readSync() {
	const state = { branch: tryGit('symbolic-ref', '--short', '-q', 'HEAD'), upstream: tryGit('rev-parse', '--abbrev-ref', '--symbolic-full-name', '@{u}'), ahead: 0, behind: 0 };
	if (state.upstream) [state.ahead, state.behind] = git('rev-list', '--left-right', '--count', 'HEAD...@{u}').split(/\s+/).map(Number);
	return state;
}
let sync;
if (existsSync(checkout)) {
	if (!dryRun) {
		try { git('fetch', '--quiet'); } catch (error) { warnings.push(`Could not fetch personal skills: ${gitError(error)}`); }
	}
	sync = readSync();
	const plan = syncPlan(sync);
	if (plan.action === 'skip') warnings.push(`Personal skills not pulled: ${plan.reason}.`);
	if (plan.action === 'pull' && dryRun) console.log(`Would fast-forward personal checkout by ${sync.behind} commits (as of last fetch).`);
	if (plan.action === 'pull' && !dryRun) {
		try {
			git('merge', '--ff-only', '--quiet', '@{u}');
			console.log(`Fast-forwarded personal checkout by ${sync.behind} commits.`);
			sync = readSync();
		} catch (error) { warnings.push(`Personal skills not pulled; local changes would be overwritten:\n${gitError(error)}`); }
	}
}
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
	if (!existsSync(checkout)) console.log(`Would clone ${personal.repository}`);
	reportWarnings();
	if (personalSkills.length) console.log(`Would link personal skills: ${personalSkills.join(', ')}`);
	process.exit(0);
}

// Skills that exist only here never reach another device.
function reportWarnings() {
	if (!sync) return;
	const unshared = unsharedSkills(tryGit('status', '--porcelain=v1', '-z'), personalSkills);
	if (unshared.length) warnings.push(`Personal skills with uncommitted changes: ${unshared.join(', ')}`);
	if (sync.ahead) warnings.push(`Personal checkout has ${sync.ahead} unpushed commits.`);
	for (const warning of warnings) console.warn(`Warning: ${warning}`);
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
reportWarnings();
if (failures.length) {
	console.error(`Unresolved skills:\n${[...new Set(failures)].join('\n')}`);
	process.exitCode = 1;
}
