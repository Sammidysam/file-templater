module FileTemplater
	class OptionParser
		# The template to load.
		attr_reader :template
		# The library to use.
		attr_reader :library
		attr_reader :verbose
		# The arguments that will be passed to the library.
		attr_reader :arguments

		def initialize(argv)

		end
	end
end
