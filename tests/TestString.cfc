component extends = "mxunit.framework.TestCase" {

	function beforeTests() {
		variables.string = new util.String();
	}

	function testEncodeForJSON() {
		local.testString = 'One"s''s\ms';

		local.result = variables.string.encodeForJSON(local.testString);

		assertEquals(local.result, 'One\"s''s\\ms');
	}
}
