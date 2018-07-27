component implements = "IContainer" {

	RequestContainer function init(string name) {
		variables.name = structKeyExists(arguments, "name") ? arguments.name : "rc_#getTickCount()#";

		request[variables.name] = {};

		return this;
	}

	void function clear() {
		structClear(request[variables.name]);
	}

	boolean function containsKey(required string key) {
		return structKeyExists(request, variables.name) && structKeyExists(request[variables.name], arguments.key);
	}

	void function destroy() {
		structDelete(request, variables.name);
	}

	any function get(required string key) {
		if(containsKey(arguments.key)) {
			return request[variables.name][arguments.key];
		}
	}

	boolean function isEmpty() {
		return !structKeyExists(request, variables.name) || structIsEmpty(request[variables.name]);
	}

	string function keyList() {
		return listSort(structKeyList(request[variables.name]), "textnocase");
	}

	void function put(required string key, required any value) {
		request[variables.name][arguments.key] = arguments.value;
	}

	void function putAll(required struct values, boolean clear = false, boolean overwrite = false) {
		if(arguments.clear) {
			this.clear();
		}

		structAppend(request[variables.name], arguments.values, arguments.overwrite);
	}

	void function remove(required string key) {
		structDelete(request[variables.name], arguments.key);
	}

	struct function values() {
		return duplicate(request[variables.name]);
	}

}