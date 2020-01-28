component accessors = "true" implements = "IContainer" {

	property name = "timeToIdleSeconds" type = "numeric";
	property name = "timeToLiveSeconds" type = "numeric";

	CacheContainer function init(required string name) {
		variables.name = lCase(arguments.name);

		// for anything more verbose, consider initializing the region prior to creating container
		if(!cacheRegionExists(variables.name)) {
			cacheRegionNew(variables.name, {}, false);
		}

		return this;
	}

	void function clear() {
		cacheRemoveAll(variables.name);
	}

	boolean function containsKey(required string key) {
		return cacheIDExists(arguments.key, variables.name);
	}

	void function destroy() {
		cacheRegionRemove(variables.name);
	}

	any function get(required string key) {
		return cacheGet(arguments.key, variables.name);
	}

	string function getName() {
		return variables.name;
	}

	boolean function isEmpty() {
		return arrayLen(cacheGetAllIDs(variables.name)) == 0;
	}

	string function keyList() {
		return listSort(arrayToList(cacheGetAllIDs(variables.name)), "textnocase");
	}

	void function put(required string key, required any value) {
		if(!structKeyExists(arguments, "timeToIdleSeconds")) {
			if(structKeyExists(variables, "timeToIdleSeconds")) {
				arguments.timeToIdleSeconds = variables.timeToIdleSeconds;
			} else {
				arguments.timeToIdleSeconds = 0;
			}
		}

		if(!structKeyExists(arguments, "timeToLiveSeconds")) {
			if(structKeyExists(variables, "timeToLiveSeconds")) {
				arguments.timeToLiveSeconds = variables.timeToLiveSeconds;
			} else {
				arguments.timeToLiveSeconds = 0;
			}
		}

		cachePut(
			arguments.key,
			arguments.value,
			arguments.timeToIdleSeconds,
			arguments.timeToLiveSeconds,
			variables.name
		);
	}

	void function putAll(required struct values, boolean clear = false, boolean overwrite = false) {
		if(arguments.clear) {
			this.clear();
		}

		for(local.key in arguments.values) {
			if(!this.containsKey(local.key) || arguments.overwrite) {
				this.put(local.key, arguments.values[local.key]);
			}
		}
	}

	void function remove(required string key) {
		cacheRemove(arguments.key, false, variables.name);
	}

	struct function values() {
		local.return = {};

		for(local.key in keyList()) {
			local.return[local.key] = get(local.key);
		}

		return local.return;
	}

}