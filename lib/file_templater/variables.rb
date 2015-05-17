module FileTemplater
	VERSION = "0.0.0"

	# The hub is where we store our templates and bindings.
	HUB = File.join(Dir.home, ".templater")
	TEMPLATE_HUB = File.join(HUB, "templates")
	BINDINGS_HUB = File.join(HUB, "bindings")
end
