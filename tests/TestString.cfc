component extends = "mxunit.framework.TestCase" {

	function beforeTests() {
		variables.stringUtil = new lib.util.String();
	}

	function test_encodeForJSON() {
		local.testString = 'One"s''s\ms';

		local.result = variables.stringUtil.encodeForJSON(local.testString);

		assertEquals(local.result, 'One\"s''s\\ms');
	}

}
