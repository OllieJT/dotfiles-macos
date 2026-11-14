import assert from 'node:assert/strict';
import test from 'node:test';
import { mkdtempSync, mkdirSync, readFileSync, readdirSync, writeFileSync, realpathSync, rmSync, statSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { installConfig } from './install-config.mjs';
import { homePath } from './file-links.mjs';

test('installation backs up originals and links shared preferences with private state outside the repository', () => {
	const temp = mkdtempSync(join(tmpdir(), 'dotfiles-config-'));
	try {
		const root = join(temp, 'repo'), home = join(temp, 'home');
		mkdirSync(join(root, 'config'), { recursive: true }); mkdirSync(home);
		writeFileSync(join(root, 'config/files.json'), JSON.stringify([{ target: '.settings.json', source: 'config/settings.json', format: 'json' }]));
		writeFileSync(join(root, 'config/settings.json'), JSON.stringify({ theme: 'dark' }));
		writeFileSync(join(home, '.settings.json'), JSON.stringify({ theme: 'dark', token: 'secret' }));
		installConfig(root, home);
		const target = join(home, '.settings.json');
		assert.ok(realpathSync(target).startsWith(realpathSync(join(home, '.local/state/dotfiles/generated'))));
		const backupRoot = join(home, '.local/state/dotfiles/backups');
		assert.deepEqual(JSON.parse(readFileSync(join(backupRoot, readdirSync(backupRoot)[0], '.settings.json'))), { theme: 'dark', token: 'secret' });
		assert.deepEqual(JSON.parse(readFileSync(target)), { theme: 'dark', token: 'secret' });
		assert.equal(statSync(realpathSync(target)).mode & 0o777, 0o600);
		writeFileSync(target, JSON.stringify({ theme: 'dark', token: 'refreshed', device: 'new' }));
		writeFileSync(join(root, 'config/settings.json'), JSON.stringify({ theme: 'light' }));
		installConfig(root, home);
		assert.deepEqual(JSON.parse(readFileSync(target)), { theme: 'light', token: 'refreshed', device: 'new' });
		assert.equal(readFileSync(join(root, 'config/settings.json'), 'utf8').includes('secret'), false);
	} finally { rmSync(temp, { recursive: true, force: true }); }
});

test('configuration targets cannot escape the home directory', () => {
	assert.throws(() => homePath('/home/example', '../elsewhere'), /inside home/);
	assert.throws(() => homePath('/home/example', '/absolute'), /inside home/);
});

test('fresh devices defer model preferences until a local provider identity exists', () => {
	const temp = mkdtempSync(join(tmpdir(), 'dotfiles-provider-'));
	try {
		const root = join(temp, 'repo'), home = join(temp, 'home');
		mkdirSync(join(root, 'config'), { recursive: true }); mkdirSync(home);
		writeFileSync(join(root, 'config/files.json'), JSON.stringify([{ target: '.settings.json', source: 'config/settings.json', format: 'json', requiresLocal: { model: 'instanceId' } }]));
		writeFileSync(join(root, 'config/settings.json'), JSON.stringify({ theme: 'dark', model: { name: 'preferred' } }));
		installConfig(root, home);
		assert.deepEqual(JSON.parse(readFileSync(join(home, '.settings.json'))), { theme: 'dark' });
		writeFileSync(join(home, '.settings.json'), JSON.stringify({ theme: 'dark', model: { name: 'app-default', instanceId: 'local' } }));
		installConfig(root, home);
		assert.deepEqual(JSON.parse(readFileSync(join(home, '.settings.json'))), { theme: 'dark', model: { name: 'preferred', instanceId: 'local' } });
	} finally { rmSync(temp, { recursive: true, force: true }); }
});
