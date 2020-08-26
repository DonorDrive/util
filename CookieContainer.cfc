component accessors = "true" implements = "IContainer" {
// TODO: support all cookie properties
	property name = "encryptionKey" type = "string" default = "";
	property name = "expires" type = "numeric" default = "30";
	property name = "httpOnly" type = "boolean" default = "true";
	property name = "sameSite" type = "string" default = "Lax";
	property name = "secure" type = "boolean" default = "false";

	CookieContainer function init(required string name) {
		variables.name = arguments.name;

		if(structKeyExists(cookie, variables.name)) {
			// deserialize if the cookie is unencrypted
			local.s = cookie[variables.name];
			if(isJson(local.s)) {
				variables.store = deserializeJson(local.s);
			}
		} else {
			variables.store = {};
		}

		return this;
	}

	void function clear() {
		structClear(variables.store);

		refreshCookie();
	}

	boolean function containsKey(required string key) {
		return structKeyExists(variables, "store") && structKeyExists(variables.store, arguments.key);
	}

	void function destroy() {
		variables.store = {};

		refreshCookie();
	}

	any function get(required string key) {
		if(containsKey(arguments.key)) {
			return variables.store[arguments.key];
		}
	}

	boolean function isEmpty() {
		return !structKeyExists(variables, "store") || structIsEmpty(variables.store);
	}

	string function keyList() {
		return listSort(structKeyList(variables.store), "textnocase");
	}

	void function put(required string key, required any value) {
		variables.store[arguments.key] = arguments.value;

		refreshCookie();
	}

	void function putAll(required struct values, boolean clear = false, boolean overwrite = false) {
		if(arguments.clear) {
			structClear(variables.store);
		}

		structAppend(variables.store, arguments.values, arguments.overwrite);

		refreshCookie();
	}

	private function refreshCookie() {
		local.s = "";

		if(structKeyExists(variables, "store") && !structIsEmpty(variables.store)) {
			local.s = serializeJson(variables.store);

			if(len(getEncryptionKey()) > 0) {
				// pad the encrypted value to prevent accidental trimming
				local.s = "[[" & encrypt(local.s, getEncryptionKey(), "AES", "base64") & "]]";
			}
		}

		cfcookie(
			expires = getExpires(),
			httpOnly = getHttpOnly(),
			name = variables.name,
			sameSite = getSameSite(),
			secure = getSecure(),
			value = local.s
		);
	}

	void function remove(required string key) {
		structDelete(variables.store, arguments.key);

		refreshCookie();
	}

	CookieContainer function setEncryptionKey(required string encryptionKey) {
		variables.encryptionKey = arguments.encryptionKey;

		if(structKeyExists(cookie, variables.name)) {
			// deserialize if the cookie is unencrypted
			try {
				local.s = reReplaceNoCase(cookie[variables.name], "(^\[\[|\]\]$)", "", "all");
				local.s = decrypt(local.s, variables.encryptionKey, "AES", "base64");
				if(isJson(local.s)) {
					variables.store = deserializeJson(local.s);
				}
			} catch(Any e) {
				// do nothin" - we'll init the store below
			}
		}

		// if the store hasn"t been initialized, do so now
		if(!structKeyExists(variables, "store")) {
			variables.store = {};
		}

		return this;
	}

	struct function values() {
		return duplicate(variables.store);
	}

}