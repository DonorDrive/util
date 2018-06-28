component {
	string function encodeForJSON(required string string) {
		// Remove ASCII characters 0-31
		local.filteredData = reReplaceNoCase(arguments.string, "[\x00-\x1F]", " ", "all");
		// Escape backslash first because they are used to escape other characters
		local.filteredData = replace(filteredData, "\", "\\", "all");

		local.filteredData = replace(filteredData, "/", "\/", "all");
		local.filteredData = replace(filteredData, '"', '\"', "all");

		return local.filteredData;
	}
}
