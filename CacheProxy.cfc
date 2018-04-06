component {

	CacheProxy function init(required IContainer container, required any target, function hasher, string methodList = "*") {
		variables.target = arguments.target;

		local.metadata = getMetadata(variables.target);

		variables.name = local.metadata.fullName;

		// extract methods + parameters from metadata
		variables.cachedMethods = arrayReduce(
			local.metadata.functions,
			function(result, method) {
				if(arguments.method.name != "init"
					&& (structKeyExists(arguments.method, "returnType") && arguments.method.returnType != "void")
					&& (methodList == "*" || listFindNoCase(methodList, arguments.method.name))
				) {
					arguments.result[arguments.method.name] = arguments.method.parameters;
				}

				return arguments.result;
			},
			{}
		);

		variables.container = arguments.container;

		if(structKeyExists(arguments, "hasher")) {
			// replace the local one
			this.hasher = arguments.hasher;
		}

		return this;
	}

	array function getMethodArguments(required string methodName) {
		return variables.cachedMethods[arguments.methodName];
	}

	string function hasher(required string methodName, required array methodArguments, required struct inputValues) {
		local.hash = "";

		for(local.argument in arguments.methodArguments) {
			if(structKeyExists(arguments.inputValues, local.argument.name)) {
				switch(structKeyExists(local.argument, "type") ? local.argument.type : "any") {
					case "any":
						if(isSimpleValue(arguments.inputValues[local.argument.name])) {
							local.hash = listAppend(local.hash, local.argument.name & "=" & arguments.inputValues[local.argument.name], ":");
						}
						break;
					case "binary":
					case "boolean":
					case "date":
					case "guid":
					case "numeric":
					case "string":
					case "uuid":
					case "xml":
						local.hash = listAppend(local.hash, local.argument.name & "=" & arguments.inputValues[local.argument.name], ":");
						break;
					default:
						// nothing we can do to establish uniqueness
						break;
				};
			}
		}

		return lCase(local.hash);
	}

	any function onMissingMethod(required missingMethodName, required missingMethodArguments) {
		if(structKeyExists(variables.cachedMethods, arguments.missingMethodName)) {
			var hash = variables.name & "." & arguments.missingMethodName & "_" & this.hasher(arguments.missingMethodName, getMethodArguments(arguments.missingMethodName), arguments.missingMethodArguments);

			if(!variables.container.containsKey(hash)) {
				variables.container.put(
					hash,
					invoke(variables.target, arguments.missingMethodName, arguments.missingMethodArguments)
				);
			}

			return variables.container.get(hash);
		} else {
			return invoke(variables.target, arguments.missingMethodName, arguments.missingMethodArguments);
		}
	}

}