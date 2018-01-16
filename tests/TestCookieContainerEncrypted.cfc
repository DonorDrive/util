component extends = "lib.util.tests.ContainerTestCase" {

	function setup() {
		variables.container = new lib.util.CookieContainer(name = "MxUnit")
			.setEncryptionKey(generateSecretKey("AES"));

		variables.container.destroy();
	}

}