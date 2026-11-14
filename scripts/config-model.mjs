export const isObject = (value) => value !== null && typeof value === 'object' && !Array.isArray(value);

export function mergeConfig(shared, local) {
	if (!isObject(shared) || !isObject(local)) return structuredClone(local);
	const result = structuredClone(shared);
	for (const [key, value] of Object.entries(local)) {
		result[key] = key in result && isObject(value) && isObject(result[key])
			? mergeConfig(result[key], value) : structuredClone(value);
	}
	return result;
}

// Retain only fields outside the tracked configuration's shape.
export function privateOverlay(current, shared) {
	if (!isObject(current) || !isObject(shared)) return undefined;
	const result = {};
	for (const [key, value] of Object.entries(current)) {
		if (!Object.hasOwn(shared, key)) result[key] = structuredClone(value);
		else if (isObject(value) && isObject(shared[key])) {
			const nested = privateOverlay(value, shared[key]);
			if (Object.keys(nested).length) result[key] = nested;
		}
	}
	return result;
}

export function privateNpmrc(current, shared) {
	const keys = new Set(shared.split('\n').map((line) => line.match(/^\s*([^#;=]+?)\s*=/)?.[1]).filter(Boolean));
	return current.split('\n').filter((line) => {
		const key = line.match(/^\s*([^#;=]+?)\s*=/)?.[1];
		return !key || !keys.has(key);
	}).join('\n').trim();
}
