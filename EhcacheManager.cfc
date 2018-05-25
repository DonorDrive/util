component {

	/*
		relevant javadoc:
			- http://www.ehcache.org/apidocs/2.10.4/net/sf/ehcache/Cache.html
			- http://www.ehcache.org/apidocs/2.10.4/net/sf/ehcache/CacheManager.html
			- http://www.ehcache.org/apidocs/2.10.4/net/sf/ehcache/config/CacheConfiguration.html
	*/

	EhcacheManager function init() {
		// the default instance
		variables.default = createObject("java", "net.sf.ehcache.CacheManager").getInstance();

    	return this;
	}

	any function addCache(required string name, string copyFrom) {
		if(!getInstance().cacheExists(arguments.name)) {
			if(structKeyExists(arguments, "copyFrom")) {
				local.config = getInstance().getCache(arguments.copyFrom).getCacheConfiguration().clone();

				local.config.name(arguments.name);

				getInstance().addCacheIfAbsent(createObject("java", "net.sf.ehcache.Cache").init(local.config));
			} else {
                getInstance().addCacheIfAbsent(arguments.name);
			}
		}

		return getCache(arguments.name);
	}

	boolean function cacheExists(required string name) {
		return getInstance().cacheExists(arguments.name);
	}

	EhcacheManager function copyAs(required string name) {
		local.config = getConfig(getManagerName());
		local.config.setName(arguments.name);

		return loadFromConfig(local.config);
	}

	any function getCache(required string name) {
		return getInstance().getCache(arguments.name);
	}

	any function getConfig(string name) {
		local.is = createObject("java", "java.io.ByteArrayInputStream").init(getConfigXML(argumentCollection = arguments).getBytes());

		return createObject("java", "net.sf.ehcache.config.ConfigurationFactory").parseConfiguration(local.is);
	}

	string function getConfigXML(string name) {
		return getInstance(argumentCollection = arguments).getOriginalConfigurationText();
	}

	any function getInstance(string name) {
		if(structKeyExists(arguments, "name")) {
			return variables.default.getCacheManager(arguments.name);
		} else if(structKeyExists(variables, "cm")) {
			return variables.cm;
		}

		return variables.default;
	}

	string function getManagerName() {
		return getInstance().getName();
	}

	array function getManagerNames() {
		return arrayReduce(
			variables.default.ALL_CACHE_MANAGERS,
			function(l, v) {
				arrayAppend(l, v.getName());

				return l;
			},
			[]
		);
	}

	EhcacheManager function loadFromConfig(required any config) {
		return new EhcacheManager().setInstance(variables.default.newInstance(arguments.config));
	}

	EhcacheManager function loadFromPath(required string path) {
		return new EhcacheManager().setInstance(variables.default.newInstance(arguments.path));
	}

	EhcacheManager function loadFromXML(required string xml) {
		local.is = createObject("java", "java.io.ByteArrayInputStream").init(arguments.xml.getBytes());

		return new EhcacheManager().setInstance(variables.default.newInstance(local.is));
	}

	boolean function managerExists(required string name) {
		return arrayFindNoCase(getManagerNames(), arguments.name);
	}

	EhcacheManager function setInstance(required any cacheManager) {
		variables.cm = arguments.cacheManager;

		return this;
	}

	void function removeCache(required string name) {
		getInstance().removeCache(arguments.name);
	}

}