import assert from 'node:assert/strict';
import test from 'node:test';
import { restoreGroups, validateSkillName } from './skills-plan.mjs';

test('restoration groups missing skills by source and preserves recorded refs', () => {
	const lock = { skills: {
		present: { sourceType: 'github', source: 'owner/repo' },
		first: { sourceType: 'github', source: 'owner/repo', ref: 'v1' },
		second: { sourceType: 'github', source: 'owner/repo', ref: 'v1' },
		bun: { sourceType: 'well-known', source: 'bun.sh' },
	} };
	assert.deepEqual(restoreGroups(lock, new Set(['present'])), [
		{ source: 'owner/repo', ref: 'v1', skills: ['first', 'second'] },
		{ source: 'https://bun.sh', ref: undefined, skills: ['bun'] },
	]);
});

test('restoration refuses unsupported or missing sources rather than silently skipping skills', () => {
	assert.throws(() => restoreGroups({ skills: { example: { sourceType: 'unknown' } } }, new Set()), /Unsupported/);
	assert.throws(() => restoreGroups({ skills: { example: { sourceType: 'github' } } }, new Set()), /Missing source/);
});

test('skill names cannot traverse out of agent directories', () => {
	for (const name of ['../outside', '/absolute', 'nested/name', '..']) assert.throws(() => validateSkillName(name), /Invalid skill name/);
});
