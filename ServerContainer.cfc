component implements = "IContainer" {

	ServerContainer function init(required string name) {
		variables.name = arguments.name;

		// make sure the store exists within server scope
		if(!structKeyExists(server, variables.name)) {
			server[variables.name] = {};
		}

		return this;
	}

	void function clear() {
		structClear(server[variables.name]);
	}

	boolean function containsKey(required string key) {
		return structKeyExists(server, variables.name) && structKeyExists(server[variables.name], arguments.key);
	}

	void function destroy() {
		structDelete(server, variables.name);
	}

	any function get(required string key) {
		if(containsKey(arguments.key)) {
			return server[variables.name][arguments.key];
		}
	}

	boolean function isEmpty() {
		return !structKeyExists(server, variables.name) || structIsEmpty(server[variables.name]);
	}

	string function keyList() {
		if(structKeyExists(server, variables.name)) {
			return listSort(structKeyList(server[variables.name]), "textnocase");
		}

		return "";
	}

	void function put(required string key, required any value) {
		server[variables.name][arguments.key] = arguments.value;
	}

	void function putAll(required struct values, boolean clear = false, boolean overwrite = false) {
		if(arguments.clear) {
			this.clear();
		}

		structAppend(server[variables.name], arguments.values, arguments.overwrite);
	}

	void function remove(required string key) {
		structDelete(server[variables.name], arguments.key);
	}

	struct function values() {
		return duplicate(server[variables.name]);
	}

}