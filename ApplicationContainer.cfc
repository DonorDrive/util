component implements = "IContainer" {

	ApplicationContainer function init(required string name) {
		variables.name = arguments.name;

		// make sure the store exists within application scope
		if(!structKeyExists(application, variables.name)) {
			application[variables.name] = {};
		}

		return this;
	}

	void function clear() {
		structClear(application[variables.name]);
	}

	boolean function containsKey(required string key) {
		return structKeyExists(application, variables.name) && structKeyExists(application[variables.name], arguments.key);
	}

	void function destroy() {
		structDelete(application, variables.name);
	}

	any function get(required string key) {
		if(containsKey(arguments.key)) {
			return application[variables.name][arguments.key];
		}
	}

	boolean function isEmpty() {
		return !structKeyExists(application, variables.name) || structIsEmpty(application[variables.name]);
	}

	string function keyList() {
		return listSort(structKeyList(application[variables.name]), "textnocase");
	}

	void function put(required string key, required any value) {
		application[variables.name][arguments.key] = arguments.value;
	}

	void function putAll(required struct values, boolean clear = false, boolean overwrite = false) {
		if(arguments.clear) {
			this.clear();
		}

		structAppend(application[variables.name], arguments.values, arguments.overwrite);
	}

	void function remove(required string key) {
		structDelete(application[variables.name], arguments.key);
	}

	struct function values() {
		return duplicate(application[variables.name]);
	}

}