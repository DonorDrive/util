component {

	ObjectToCache function init() {
		return this;
	}

	string function echoWithTickCount(required string echo, numeric sleep = 0) {
		if(arguments.sleep > 0) {
			sleep(arguments.sleep);
		}

		return getTickCount() & " " & arguments.echo;
	}

	void function static() {
		return;
	}

	numeric function typelessMethod(bar, foo) {
		return bar + foo;
	}

}
