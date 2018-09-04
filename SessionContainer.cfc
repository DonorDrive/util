component implements = "IContainer" {

	SessionContainer function init(required string name) {
		variables.name = arguments.name;

		// make sure the store exists within session scope
		if(!structKeyExists(session, variables.name)) {
			session[variables.name] = {};
		}

		return this;
	}

	void function clear() {
		structClear(session[variables.name]);
	}

	boolean function containsKey(required string key) {
		return structKeyExists(session, variables.name) && structKeyExists(session[variables.name], arguments.key);
	}

	void function destroy() {
		structDelete(session, variables.name);
	}

	any function get(required string key) {
		if(containsKey(arguments.key)) {
			return session[variables.name][arguments.key];
		}
	}

	boolean function isEmpty() {
		return !structKeyExists(session, variables.name) || structIsEmpty(session[variables.name]);
	}

	string function keyList() {
		return listSort(structKeyList(session[variables.name]), "textnocase");
	}

	void function put(required string key, required any value) {
		session[variables.name][arguments.key] = arguments.value;
	}

	void function putAll(required struct values, boolean clear = false, boolean overwrite = false) {
		if(arguments.clear) {
			this.clear();
		}

		structAppend(session[variables.name], arguments.values, arguments.overwrite);
	}

	void function remove(required string key) {
		structDelete(session[variables.name], arguments.key);
	}

	struct function values() {
		return duplicate(session[variables.name]);
	}

}