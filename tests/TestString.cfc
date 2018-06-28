component extends = "mxunit.framework.TestCase" {

	function beforeTests() {
		variables.string = new lib.util.String();
	}

	function test_encodeForJSON() {
		local.testString = 'One"s''s\ms';

		local.result = variables.string.encodeForJSON(local.testString);

		assertEquals(local.result, 'One\"s''s\\ms');
	}
}
