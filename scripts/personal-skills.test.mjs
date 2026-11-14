import assert from 'node:assert/strict';
import test from 'node:test';
import { existsSync, lstatSync, mkdirSync, mkdtempSync, rmSync, symlinkSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { discoverPersonalSkills, removeBlacklistedLinks, validateBlacklist } from './personal-skills.mjs';

function fixture(run) {
	const root = mkdtempSync(join(tmpdir(), 'dotfiles-personal-skills-'));
	try { run(root); } finally { rmSync(root, { recursive: true, force: true }); }
}
function skill(root, name) {
	mkdirSync(join(root, name), { recursive: true });
	writeFileSync(join(root, name, 'SKILL.md'), '# Example skill\n');
}

test('discovery includes new skills automatically and excludes blacklisted, hidden and non-skill folders', () => fixture((root) => {
	for (const name of ['working', 'excluded', '.metadata']) skill(root, name);
	mkdirSync(join(root, 'assets'));
	mkdirSync(join(root, 'not-a-skill/SKILL.md'), { recursive: true });
	writeFileSync(join(root, 'README.md'), 'Repository documentation');
	assert.deepEqual(discoverPersonalSkills(root, ['excluded']), ['working']);
	skill(root, 'new-skill');
	assert.deepEqual(discoverPersonalSkills(root, ['excluded']), ['new-skill', 'working']);
}));

test('blacklist accepts folder names but rejects paths and traversal', () => {
	validateBlacklist(['draft', '.metadata']);
	for (const value of [['../outside'], ['/absolute'], ['..'], ['nested/path'], ['nested\\path'], 'draft']) {
		assert.throws(() => validateBlacklist(value), /folder names/);
	}
});

test('blacklisting unlinks personal skills through both link styles while preserving their sources', () => fixture((root) => {
	const checkout = join(root, 'checkout'), canonical = join(root, 'canonical'), agent = join(root, 'agent');
	for (const directory of [checkout, canonical, agent]) mkdirSync(directory);
	for (const name of ['direct', 'indirect']) {
		skill(checkout, name);
		symlinkSync(join(checkout, name), join(canonical, name));
		symlinkSync(join(name === 'direct' ? checkout : canonical, name), join(agent, name));
	}
	assert.equal(removeBlacklistedLinks(checkout, ['direct', 'indirect'], [canonical, agent], canonical).length, 4);
	for (const name of ['direct', 'indirect']) {
		assert.ok(existsSync(join(checkout, name, 'SKILL.md')));
		assert.equal(existsSync(join(canonical, name)), false);
		assert.equal(existsSync(join(agent, name)), false);
	}
}));

test('blacklisting preserves unrelated links, independent copies and remote canonical skills', () => fixture((root) => {
	const checkout = join(root, 'checkout'), canonical = join(root, 'canonical'), agent = join(root, 'agent');
	for (const directory of [checkout, canonical, agent]) mkdirSync(directory);
	skill(canonical, 'remote');
	symlinkSync(join(canonical, 'remote'), join(agent, 'remote'));
	skill(agent, 'independent');
	skill(root, 'elsewhere');
	symlinkSync(join(root, 'elsewhere'), join(canonical, 'unrelated'));
	assert.deepEqual(removeBlacklistedLinks(checkout, ['remote', 'independent', 'unrelated'], [canonical, agent], canonical), []);
	assert.ok(existsSync(join(agent, 'independent/SKILL.md')));
	assert.ok(lstatSync(join(agent, 'remote')).isSymbolicLink());
	assert.ok(lstatSync(join(canonical, 'unrelated')).isSymbolicLink());
}));
