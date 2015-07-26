module FileTemplater
	VERSION = "0.1.2"

	# The hub is where we store our templates and bindings.
	HUBS = {
		:main => File.join(Dir.home, ".templater"),
		:template => File.join(Dir.home, ".templater", "templates"),
		:binding => File.join(Dir.home, ".templater", "bindings"),
		:original => File.join(Dir.home, ".templater", "original")
	}
end
