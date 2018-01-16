component extends = "donordrive.util.tests.ContainerTestCase" {

	function setup() {
		variables.container = new donordrive.util.RequestContainer(name = "MxUnit");
	}

	function test_scope() {
		local.value = getTickCount();
		variables.container.put("MxUnit_test_scope", local.value);

		assertEquals(local.value, request["MxUnit"]["MxUnit_test_scope"]);
	}

}