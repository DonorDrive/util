component extends = "lib.util.tests.ContainerTestCase" {

	function setup() {
		variables.container = new lib.util.ApplicationContainer(name = "MxUnit");

		variables.container.clear();
	}

	function test_scope() {
		local.value = getTickCount();
		variables.container.put("MxUnit_test_scope", local.value);

		assertEquals(local.value, application["MxUnit"]["MxUnit_test_scope"]);
	}

}