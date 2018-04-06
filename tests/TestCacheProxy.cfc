component extends = "mxunit.framework.TestCase" {

	function beforeTests() {
		variables.cacheProxy = new lib.util.CacheProxy(
			container = new lib.util.SimpleContainer(),
			target = new lib.util.tests.ObjectToCache()
		);
	}

	function test_hasher_default() {
		local.hash = variables.cacheProxy.hasher(
			"echoWithTickcount",
			variables.cacheProxy.getMethodArguments("echoWithTickcount"),
			{
				echo: "foo",
				sleep: 1
			}
		);

		assertEquals("echo=foo:sleep=1", local.hash);
	}

	function test_hasher_default_typeless() {
		local.hash = variables.cacheProxy.hasher(
			"typelessMethod",
			variables.cacheProxy.getMethodArguments("typelessMethod"),
			{
				bar: 1,
				foo: 2,
				extra: {}
			}
		);

		assertEquals("bar=1:foo=2", local.hash);
	}

	function test_hasher_override() {
		local.hasher = function() {
			return "bub";
		};

		local.cacheProxy = new lib.util.CacheProxy(
			container = new lib.util.SimpleContainer(),
			hasher = local.hasher,
			target = new lib.util.tests.ObjectToCache()
		);

		local.hash = local.cacheProxy.hasher(
			"typelessMethod",
			variables.cacheProxy.getMethodArguments("typelessMethod"),
			{
				bar: 1,
				foo: 2,
				extra: {}
			}
		);

		assertEquals("bub", local.hash);
	}


	function test_onMissingMethod_echoWithTickcount() {
		local.result1 = variables.cacheProxy.echoWithTickcount(echo = "Test", sleep = 100);
		local.result2 = variables.cacheProxy.echoWithTickcount(echo = "Test", sleep = 100);
		local.result3 = variables.cacheProxy.echoWithTickcount(echo = "Test 2");

		assertEquals(local.result1, local.result2);
		assertNotEquals(local.result1, local.result3);
	}

	function test_onMissingMethod_static() {
		local.result1 = variables.cacheProxy.static();

		assertTrue(isNull(local.result1));
	}

	function test_onMissingMethod_typelessMethod() {
		local.result1 = variables.cacheProxy.typelessMethod(100, 200);
		local.result2 = variables.cacheProxy.typelessMethod(100, 200);

		assertEquals(300, local.result1);
		assertEquals(local.result1, local.result2);
	}

}