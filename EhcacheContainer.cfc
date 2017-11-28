component implements = 'IContainer' {

	EhcacheContainer function init(required string name) {
		variables.name = arguments.name;

		// for anything more verbose, consider initializing the region prior to creating container
		if(!cacheRegionExists(variables.name)) {
			cacheRegionNew(variables.name);
		}

		return this;
	}

	void function clear() {
		cacheRemoveAll(variables.name);
	}

	boolean function containsKey(required string key) {
		return cacheRegionExists(variables.name) && cacheIdExists(arguments.key, variables.name);
	}

	void function delete(required string key) {
		cacheRemove(arguments.key, false, variables.name);
	}

	void function destroy() {
		cacheRegionRemove(variables.name);
	}

	any function get(required string key) {
		if(containsKey(arguments.key)) {
			return cacheGet(arguments.key, variables.name);
		}
	}

	boolean function isEmpty() {
		return !cacheRegionExists(variables.name) || arrayLen(cacheGetAllIds(variables.name, false)) == 0;
	}

	string function keyList() {
		return listSort(arrayToList(cacheGetAllIds(variables.name)), 'textnocase');
	}

	void function put(required string key, required any value) {
		cachePut(arguments.key, arguments.value, '', '', variables.name);
	}

	void function putAll(required struct values, boolean clear = false, boolean overwrite = false) {
		if(arguments.clear) {
			this.clear();
		}

		for(local.key in arguments.values) {
			if(!containsKey(local.key) || arguments.overwrite) {
				put(local.key, arguments.values[local.key]);
			}
		}
	}

	struct function values() {
		local.return = {};

		for(local.key in keyList()) {
			local.return[local.key] = get(local.key);
		}

		return local.return;
	}

}