module FileTemplater
	class OptionsHandler
		def initialize(argv)
			@nomodify = false

			@actions = []

			parser = OptionParser.new do |o|
				o.banner = "Usage: template [options]"

				o.separator ""
				o.separator "Specific options:"

				o.on("-t", "--template TEMPLATE",
					 "Load TEMPLATE to insert",
					 "into the current directory") do |t|
					@actions << [:template, t]
				end

				o.on("-a", "--add THING", Array,
					 "Add THING, a template or a binding,",
					 "to the template or binding directory") do |t|
					@actions << [:add, t]
				end

				o.on("-r", "--remove THING", Array,
					 "Removes template or binding THING") do |tb|
					@actions << [:remove, tb]
				end

				o.on("-l", "--list",
					 "Lists the templates and bindings",
					 "that are loaded") do
					@actions << [:list]
				end

				o.on("-m", "--no-modify",
					 "Prevents modifying the template source",
					 "when loading") do
					@nomodify = true
				end

				o.on("-c", "--copy TEMPLATE", Array,
					 "Copies TEMPLATE and corresponding binding",
					 "into current directory") do |tb|
					@actions << [:copy, tb]
				end

				o.separator ""
				o.separator "Common options:"

				o.on_tail("-v", "--version", "Display the version") do
					puts "File Templater (template) version " + VERSION
					exit
				end

				o.on_tail("-h", "--help", "Show this message") do
					puts o
					exit
				end
			end

			parser.parse!(argv)
			@arguments = argv
		end

		def process_actions
			@actions.each do |a|
				command = a.first
				arguments = a[1]

				case command
				when :template
					# arguments is the template name,
					# @arguments are the extraneous arguments
					template = Template.new(arguments, @arguments, nomodify: @nomodify)
					template.load
				when :add
					arguments.each do |ar|
						FileActions.add(ar)
					end
				when :remove
					arguments.each do |ar|
						FileActions.remove(ar)
					end
				when :list
					puts FileActions.list
				when :copy
					arguments.each do |ar|
						FileActions.copy(ar)
					end
				end
			end
		end
	end
end
