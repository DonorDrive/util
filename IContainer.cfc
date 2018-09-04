interface {

	/* roughly follows the pattern defined by java.util.Map */

	void function clear();

	boolean function containsKey(required string key);

	void function destroy();

	any function get(required string key);

	boolean function isEmpty();

	string function keyList();

	void function put(required string key, required any value);

	void function putAll(required struct values, boolean clear = false, boolean overwrite = false);

	void function remove(required string key);

	struct function values();

}