component implements = "IContainer" {

	SimpleContainer function init() {
		variables.store = {};

		return this;
	}

	void function clear() {
		if(structKeyExists(variables, "store")) {
			structClear(variables.store);
		}
	}

	boolean function containsKey(required string key) {
		return structKeyExists(variables, "store") && structKeyExists(variables.store, arguments.key);
	}

	void function destroy() {
		structDelete(variables, "store");
	}

	any function get(required string key) {
		if(this.containsKey(arguments.key)) {
			return variables.store[arguments.key];
		}
	}

	boolean function isEmpty() {
		return !structKeyExists(variables, "store") || structIsEmpty(variables.store);
	}

	string function keyList() {
		return this.isEmpty() ? "" : listSort(structKeyList(variables.store), "textnocase");
	}

	void function put(required string key, required any value) {
		variables.store[arguments.key] = arguments.value;
	}

	void function putAll(required struct values, boolean clear = false, boolean overwrite = false) {
		if(arguments.clear) {
			this.clear();
		}

		structAppend(variables.store, arguments.values, arguments.overwrite);
	}

	void function remove(required string key) {
		structDelete(variables.store, arguments.key);
	}

	struct function values() {
		return duplicate(variables.store);
	}

}