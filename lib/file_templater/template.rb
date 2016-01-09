module FileTemplater
	class Template
		# options can include:
		# bind: which binding rather than the default to use
		# nomodify: if the template ERB will be loaded or not
		def initialize(template, arguments, options = {})
			@name = template
			@nomodify = options[:nomodify]

			@template = File.join(HUBS[:template], template)
			binding_string = options[:bind] || template + ".rb"
			binding_file = File.join(HUBS[:binding], binding_string)
			using_binding = File.exist?(binding_file)

			if using_binding
				# Load the binding.
                FileActions.require_binding(binding_string)

				# Get the binding class name from the binding file,
				# and create an instance of it.
				binding_class = Object.const_get("Bindings::" + FileActions.get_class_name(binding_file))
				@bind = binding_class.new(*arguments)
			end
		end

		def load(folder = @template)
			unless folder == @template
				FileUtils.mkdir(File.join(Dir.pwd, File.basename(folder)))
				puts "Created folder #{File.join(Dir.pwd, File.basename(folder))}"
			end

			FileActions.unique_directory_list(folder).each do |f|
				f = File.join(folder, f)
				short_path = f.gsub(HUBS[:template] + File::SEPARATOR + @name, "")

				if File.directory?(f)
					self.load f
				else
					if !@nomodify && f.end_with?(".erb")
						output_file = File.open(File.join(Dir.pwd, transform_file_name(short_path)), "w")

						input_file = File.open(f, "r")
						output_file.print(ERB.new(input_file.read, nil, "<>").result(@bind && @bind.get_binding))
						input_file.close

						output_file.close
					else
						FileUtils.copy_entry(f, File.join(Dir.pwd, transform_file_name(short_path)))
					end

					puts "Created file #{File.join(Dir.pwd, transform_file_name(short_path))}"
				end
			end
		end

		# Expands the variable-in-file-name notation.
		def transform_file_name(file)
			if @bind
				variables = file.scan(/{{([^}]*)}}/).flatten

				variables.each do |v|
					file.sub!("{{#{v}}}", @bind.get_binding.eval(v))
				end
			end

			(!@nomodify && file.end_with?(".erb") && !File.directory?(file)) ? File.basename(file, ".*") : file
		end
	end
end
