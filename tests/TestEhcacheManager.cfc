component extends = "mxunit.framework.TestCase" {

	function beforeTests() {
		try {
			variables.cacheManager = new lib.util.EhcacheManager();
		} catch(Any e) {
			variables.exception = e;
		}
	}

	function afterTests() {
		variables.cacheManager.getCache("mxunitCache").flush();
//		variables.cacheManager.removeCache("mxunitCache");

		variables.cacheManager.getCache("mxunitCache2").flush();
//		variables.cacheManager.removeCache("mxunitCache2");

		variables.cacheManager.getCache("mxunitCache3").flush();
//		variables.cacheManager.removeCache("mxunitCache3");

		variables.cacheManager.getCache("mxunitCache4").flush();
//		variables.cacheManager.removeCache("mxunitCache3");

//		variables.cacheManager.removeCache("mxunitCache_default");
//		variables.cacheManager.removeCache("mxunitCache_override");
	}
/*
	function testAddCache_default() {

		variables.cacheManager.addCache("mxunitCache_default");

		assertTrue(variables.cacheManager.cacheExists("mxunitCache_default"));
	}
 */
/*
	function testAddCache_override() {
		variables.cacheManager.addCache("mxunitCache_override", "mxunitCache");

		assertTrue(variables.cacheManager.cacheExists("mxunitCache_override"));
	}
 */
	function testCopyAs() {
		local.cacheManager = variables.cacheManager.copyAs("mxunitCacheManager4");
		local.cacheManager.addCache("mxunitCache4");

		cachePut("element", { "meep": "bleep" }, "", "", "mxunitCache4");

		assertEquals("mxunitCacheManager4", local.cacheManager.getManagerName());
		assertTrue(cacheRegionExists("mxunitCache4"));
	}

	function testGetCache() {
//		assertEquals("lib.ehcache.Cache", getMetadata(variables.cacheManager.getCache("mxunitCache")).fullName);
	}

	function testGetConfigXML() {
		debug(variables.cacheManager.getConfigXML());
	}

	function testGetInstance() {
// debug(variables.exception); return;
		debug(variables.cacheManager.getInstance());
	}

	function testGetManagerNames() {
		debug(variables.cacheManager.getManagerNames());
	}

	function testLoadFromConfig() {
		local.config = variables.cacheManager.getConfig();
		local.config.setName("mxunitCacheManager2");

		local.cacheManager = variables.cacheManager.loadFromConfig(local.config);
		local.cacheManager.addCache("mxunitCache2");

		cachePut("element", { "meep": "bleep" }, "", "", "mxunitCache2");

		assertEquals("mxunitCacheManager2", local.cacheManager.getManagerName());
		assertTrue(cacheRegionExists("mxunitCache2"));
	}

	function testLoadFromPath() {
		local.cacheManager = variables.cacheManager.loadFromPath(expandPath("/lib/util/tests/test.xml.cfm"));

		cachePut("element", { "meep": "bleep" }, "", "", "mxunitCache");

		assertEquals("mxunitCacheManager", local.cacheManager.getManagerName());
		assertTrue(cacheRegionExists("mxunitCache"));
	}

	function testLoadFromXML() {
		local.cacheManager = variables.cacheManager.loadFromXML(
			'<ehcache name="mxunitCacheManager3">
				<defaultCache
					clearOnFlush="true"
					diskExpiryThreadIntervalSeconds="3600"
					diskPersistent="false"
					diskSpoolBufferSizeMB="30"
					eternal="false"
					maxElementsInMemory="10000"
					maxElementsOnDisk="10000000"
					memoryStoreEvictionPolicy="LRU"
					overflowToDisk="false"
					timeToIdleSeconds="86400"
					timeToLiveSeconds="86400"
					statistics="false" />
				<cache
					name="mxunitCache3"
					maxEntriesLocalHeap="10000"
					timeToIdleSeconds="3600"
					timeToLiveSeconds="3600">
				</cache>
			</ehcache>'
		);

		cachePut("element", { "meep": "bleep" }, "", "", "mxunitCache3");

		assertEquals("mxunitCacheManager3", local.cacheManager.getManagerName());
	}

}