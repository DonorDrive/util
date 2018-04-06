component extends = "mxunit.framework.TestCase" {

	function beforeTests() {
		variables.cacheProxy = new lib.util.CacheProxy(
			container = new lib.util.SimpleContainer(),
			target = new lib.util.tests.ObjectToCache()
		);
	}

	function test_defaultHasher() {
		local.hash = variables.cacheProxy.defaultHasher(
			variables.cacheProxy.getMethodArguments("echoWithTickcount"),
			{
				echo: "foo",
				sleep: 1
			}
		);

		assertEquals("echo=foo:sleep=1", local.hash);
	}

	function test_defaultHasher_typeless() {
		local.hash = variables.cacheProxy.defaultHasher(
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