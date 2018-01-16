component extends = "lib.util.tests.ContainerTestCase" {

	function setup() {
		variables.container = new lib.util.ServerContainer(name = "MxUnit");

		variables.container.clear();
	}

	function test_scope() {
		local.value = getTickCount();
		variables.container.put("MxUnit_test_scope", local.value);

		assertEquals(local.value, server["MxUnit"]["MxUnit_test_scope"]);
	}

}