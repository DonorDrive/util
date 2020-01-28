component {

	string function encodeForJSON(required string string) {
		// Remove ASCII characters 0-31
		arguments.string = reReplaceNoCase(arguments.string, "[\x00-\x1F]", " ", "all");
		// Escape backslash first because they are used to escape other characters
		arguments.string = replace(arguments.string, "\", "\\", "all");

		arguments.string = replace(arguments.string, "/", "\/", "all");
		arguments.string = replace(arguments.string, '"', '\"', "all");

		return arguments.string;
	}

}
