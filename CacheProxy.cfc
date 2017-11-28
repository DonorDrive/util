component {

	CacheProxy function init(required IContainer container, required any target, function hasher, string methodList = '*') {
		variables.target = arguments.target;

		local.metadata = getMetadata(variables.target);

		variables.name = local.metadata.fullName;

		// extract methods + parameters from metadata
		variables.cachedMethods = arrayReduce(
			local.metadata.functions,
			function(result, method) {
				if(arguments.method.name != 'init'
					&& (structKeyExists(arguments.method, 'returnType') && arguments.method.returnType != 'void')
					&& (methodList == '*' || listFindNoCase(methodList, arguments.method.name))
				) {
					arguments.result[arguments.method.name] = arguments.method.parameters;
				}

				return arguments.result;
			},
			{}
		);

		variables.container = arguments.container;

		if(!structKeyExists(arguments, 'hasher')) {
			variables.hasher = defaultHasher;
		}

		return this;
	}

	string function defaultHasher(required array methodArguments, required struct inputValues) {
		local.hash = '';

		for(local.argument in arguments.methodArguments) {
			if(structKeyExists(arguments.inputValues, local.argument.name)) {
				switch(local.argument.type ?: 'any') {
					case 'any':
						if(isSimpleValue(arguments.inputValues[local.argument.name])) {
							local.hash = listAppend(local.hash, local.argument.name & ':' & arguments.inputValues[local.argument.name], ';');
						}
						break;
					case 'binary':
					case 'boolean':
					case 'date':
					case 'guid':
					case 'numeric':
					case 'string':
					case 'uuid':
					case 'xml':
						local.hash = listAppend(local.hash, local.argument.name & ':' & arguments.inputValues[local.argument.name], ';');
						break;
					default:
						// nothing we can do to establish uniqueness
						break;
				};
			}
		}

		return hash(lCase(local.hash), 'MD5', 'UTF-8');
	}

	array function getMethodArguments(required string methodName) {
		return variables.cachedMethods[arguments.methodName];
	}

	any function onMissingMethod(required missingMethodName, required missingMethodArguments) {
		if(structKeyExists(variables.cachedMethods, arguments.missingMethodName)) {
			var hash = variables.name & '.' & arguments.missingMethodName & '.' & variables.hasher(getMethodArguments(arguments.missingMethodName), arguments.missingMethodArguments);

			if(!variables.container.containsKey(hash)) {
				var method = variables.target[arguments.missingMethodName];
				var result = method(argumentCollection = arguments.missingMethodArguments);
				variables.container.put(hash, result);
			}

			return variables.container.get(hash);
		} else {
			var method = variables.target[arguments.missingMethodName];
			return method(argumentCollection = arguments.missingMethodArguments);
		}
	}

}