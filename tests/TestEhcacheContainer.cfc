component extends = "lib.util.tests.ContainerTestCase" {

	function beforeTests() {
		variables.container = new lib.util.EhcacheContainer(name = "MxUnit");
	}

	function setup() {
		variables.container.clear();
	}

	function test_destroy() {
//		variables.container.put("MxUnitTest_destroy", "MxUnitTest_destroy_value");
//		variables.container.destroy();
//		assertTrue(variables.container.isEmpty());
	}

	function test_scope() {
		local.value = getTickCount();
		variables.container.put("MxUnit_test_scope", local.value);

		assertEquals(local.value, variables.container.get("MxUnit_test_scope"));
	}

	function test_zzz_destroy() {
		variables.container.put("MxUnitTest_destroy", "MxUnitTest_destroy_value");
		variables.container.destroy();
		assertTrue(variables.container.isEmpty());
	}

}