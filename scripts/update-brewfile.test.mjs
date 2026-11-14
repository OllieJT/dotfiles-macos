import assert from 'node:assert/strict';
import test from 'node:test';
import { filterBrewfile, parseBlacklist } from './update-brewfile.mjs';

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
