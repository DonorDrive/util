component extends = "lib.util.tests.ContainerTestCase" {

	function setup() {
		variables.container = new lib.util.SessionContainer(name = "MxUnit");
	}

	function test_scope() {
		local.value = getTickCount();
		variables.container.put("MxUnit_test_scope", local.value);

		assertEquals(local.value, session["MxUnit"]["MxUnit_test_scope"]);
	}

}