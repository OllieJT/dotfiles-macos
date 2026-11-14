import assert from 'node:assert/strict';
import test from 'node:test';
import { filterBrewfile, includeRequiredCasks, parseBlacklist, parseRequiredCasks } from './update-brewfile.mjs';

test('blacklist accepts IDs, comments and blank lines, and deduplicates IDs', () => {
	assert.deepEqual([...parseBlacklist('# Apps\r\n\r\n1521082061 # Alfread\r\n1521082061\r\n')], ['1521082061']);
});

test('blacklist rejects names and malformed IDs with the line number', () => {
	for (const invalid of ['Alfread', '123 trailing text', '-123', '1.5']) {
		assert.throws(() => parseBlacklist(`# Apps\n${invalid}`), /Invalid App Store ID on blacklist line 2/);
	}
});

test('refresh excludes exact blacklisted IDs while including other apps and package types', () => {
	const snapshot = 'tap "example/tap"\ncask "alfread"\nmas "Renamed app", id: 123\nmas "Another app", id: 1234\nmas "New discovery", id: 456\nvscode "example.extension"\n';
	assert.equal(filterBrewfile(snapshot, new Set(['123'])), 'tap "example/tap"\ncask "alfread"\nmas "Another app", id: 1234\nmas "New discovery", id: 456\nvscode "example.extension"\n');
});

test('required casks accept comments and reject malformed package names', () => {
	assert.deepEqual([...parseRequiredCasks('# Apps\nghostty # terminal\nghostty\n')], ['ghostty']);
	assert.throws(() => parseRequiredCasks('ghostty\nnot a cask'), /Invalid required cask on line 2/);
});

test('refresh retains required apps installed outside Homebrew without duplicating recorded casks', () => {
	const snapshot = 'cask "iterm2", greedy: true\nmas "Example", id: 123\n';
	const output = includeRequiredCasks(snapshot, new Set(['ghostty', 'iterm2']));
	assert.equal(output, snapshot + '\n# Additional apps to install\ncask "ghostty"\n');
	assert.equal(includeRequiredCasks(output, new Set(['ghostty', 'iterm2'])), output);
});
