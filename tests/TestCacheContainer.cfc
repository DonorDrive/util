component extends = "lib.util.tests.ContainerTestCase" {

	function afterTests() {
		variables.container.destroy();
	}

	function beforeTests() {
		variables.container = new lib.util.CacheContainer(name = "MxUnit");
	}

	function setup() {
		variables.container.clear();
	}

	function test_destroy() {
		// CF's cache implementations aren't meant to be torn down at this frequency - wait until the very end of the suite
	}

}