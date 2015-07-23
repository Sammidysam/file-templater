module FileTemplater
	class Template
		# options can include:
		# bind: which binding rather than the default to use
		# nomodify: if the template ERB will be loaded or not
		def initialize(template, arguments, options = {})
			@nomodify = options[:nomodify]

			@template = File.join(HUBS[:template], template)
			binding_string = options[:bind] || template + ".rb"
			binding_string = File.basename(binding_string, ".*")

			# Convert binding_string to a class object.
			binding_string = "Bindings::" + binding_string.split("_").map { |w| w.capitalize }.join
			binding_class = Object.const_get(binding_string)
			@bind = binding_class.new(*arguments)
		end

		def load(folder = @template)
			FileActions.unique_directory_list(folder).each do |f|
				# We need the whole path to f, but we will keep the short name.
				short_name = f
				f = File.join(folder, f)

				if File.directory?(f)
					self.load f
				else
					if !@nomodify && f.end_with?(".erb")
						output_file = File.open(File.join(Dir.pwd, transform_file_name(short_name)), "w")

						input_file = File.open(f, "r")
						output_file.print(ERB.new(input_file.read, nil, "<>").result(@bind.get_binding))
						input_file.close

						output_file.close
					else
						FileUtils.copy_entry(f, File.join(Dir.pwd, transform_file_name(short_name)))
					end
				end
			end
		end

		# Expands the variable-in-file-name notation.
		# file is expected to be a short name
		def transform_file_name(file)
			variables = file.scan(/{{([^}]*)}}/).flatten

			variables.each do |v|
				file.sub!("{{#{v}}}", @bind.get_binding.eval(v))
			end

			!@nomodify && file.end_with?(".erb") ? File.basename(file, ".*") : file
		end
	end
end
