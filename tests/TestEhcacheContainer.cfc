component extends = 'donordrive.util.tests.ContainerTestCase' {

	function setup() {
		variables.container = new donordrive.util.EhcacheContainer(name = 'MxUnit');

		variables.container.clear();
	}

	function test_scope() {
		local.value = getTickCount();
		variables.container.put('MxUnit_test_scope', local.value);

		assertEquals(local.value, cacheGet('MxUnit_test_scope', 'MxUnit'));
	}

}