import assert from 'node:assert/strict';
import test from 'node:test';
import { mergeConfig, privateOverlay, privateNpmrc } from './config-model.mjs';

test('portable model settings merge with local IDs and credentials without tracking them', () => {
	const shared = { model: { name: 'preferred', options: { effort: 'high' } }, appearance: 'dark' };
	const current = { ...shared, model: { ...shared.model, instanceId: 'local-provider' }, token: 'private-token', directory: '/local/path' };
	const local = privateOverlay(current, shared);
	assert.deepEqual(local, { model: { instanceId: 'local-provider' }, token: 'private-token', directory: '/local/path' });
	assert.deepEqual(mergeConfig(shared, local), current);
	assert.equal(JSON.stringify(shared).includes('private-token'), false);
});

test('shared preferences take precedence while local arrays and nested state survive', () => {
	const current = { font: 'old', models: ['old'], device: { id: 'local' } };
	const shared = { font: 'new', models: ['new'] };
	assert.deepEqual(mergeConfig(shared, privateOverlay(current, shared)), { ...shared, device: current.device });
});

test('npm authentication remains local while the shared release-age setting replaces its old value', () => {
	assert.equal(privateNpmrc('//registry.npmjs.org/:_authToken=private\nmin-release-age=1\n', 'min-release-age=2\n'), '//registry.npmjs.org/:_authToken=private');
});
