component extends = 'donordrive.util.tests.ContainerTestCase' {

	function setup() {
		variables.container = new donordrive.util.CookieContainer(name = 'MxUnit')
			.setEncryptionKey(generateSecretKey('AES'));

		variables.container.destroy();
	}

}