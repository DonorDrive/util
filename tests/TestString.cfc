component extends = "mxunit.framework.TestCase" {

	function beforeTests() {
		variables.string = new util.String();
	}

	function testEscapeJSONcharacters() {
		local.testString = 'One"s''s\ms';

		local.result = variables.string.escapeJSONcharacters(local.testString);

		assertEquals(local.result, 'One\"s''s\\ms');
	}
}
