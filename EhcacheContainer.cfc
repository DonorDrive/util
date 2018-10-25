component accessors = "true" implements = "IContainer" {

	property name = "timeToIdleSeconds" type = "numeric" default = "0";
	property name = "timeToLiveSeconds" type = "numeric" default = "0";

	EhcacheContainer function init(required string name, string managerName) {
		variables.name = arguments.name;

		if(structKeyExists(arguments, "managerName")) {
			// the named CacheManager
			variables.cacheManager = createObject("java", "net.sf.ehcache.CacheManager").getCacheManager(arguments.managerName);
		} else {
			// the default/singleton CacheManager
			variables.cacheManager = createObject("java", "net.sf.ehcache.CacheManager").getInstance();
		}

		// for anything more verbose, consider initializing the region prior to creating container
		variables.cache = variables.cacheManager.addCacheIfAbsent(javaCast("string", arguments.name));

		return this;
	}

	void function clear() {
		variables.cache.removeAll();
	}

	boolean function containsKey(required string key) {
		return variables.cache.isKeyInCache(arguments.key);
	}

	void function destroy() {
		variables.cacheManager.removeCache(variables.name);
	}

	any function get(required string key) {
		local.element = variables.cache.get(arguments.key);

		if(!isNull(local.element)) {
			return local.element.getObjectValue();
		}
	}

	any function getCache() {
		return variables.cache;
	}

	any function getManager() {
		return variables.cacheManager;
	}

	boolean function isEmpty() {
		return variables.cacheManager.cacheExists(variables.name) ? variables.cache.getKeysWithExpiryCheck().size() == 0 : true;
	}

	string function keyList() {
		return listSort(arrayToList(variables.cache.getKeysWithExpiryCheck()), "textnocase");
	}

	void function put(required string key, required any value) {
		variables.cache.put(
			createObject("java", "net.sf.ehcache.Element")
				.init(
					arguments.key,
					arguments.value,
					getTimeToIdleSeconds(),
					getTimeToLiveSeconds()
				)
			);
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

	void function remove(required string key) {
		variables.cache.remove(arguments.key);
	}

	struct function values() {
		local.return = {};

		for(local.key in keyList()) {
			local.return[local.key] = get(local.key);
		}

		return local.return;
	}

}