export function validateSkillName(name) {
	if (!/^[a-zA-Z0-9][a-zA-Z0-9._-]*$/.test(name)) throw new Error(`Invalid skill name: ${name}`);
	return name;
}

export function restoreGroups(lock, installed) {
	const groups = new Map();
	for (const [name, entry] of Object.entries(lock.skills)) {
		validateSkillName(name);
		if (installed.has(name)) continue;
		if (!['github', 'git', 'well-known'].includes(entry.sourceType)) throw new Error(`Unsupported skill source type for ${name}: ${entry.sourceType}`);
		const source = entry.sourceUrl || (entry.sourceType === 'well-known' ? `https://${entry.source}` : entry.source);
		if (!source) throw new Error(`Missing source for ${name}`);
		const ref = entry.commit || entry.ref;
		const key = JSON.stringify([source, ref]);
		if (!groups.has(key)) groups.set(key, { source, ref, skills: [] });
		groups.get(key).skills.push(entry.skillName || name);
	}
	return [...groups.values()];
}
