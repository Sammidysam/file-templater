module FileTemplater
	class FileActions
		class << self
			def create_hub_if_necessary
				HUBS.each do |k, v|
					Dir.mkdir(v) unless Dir.exists?(v)
				end
			end

			def add(path)
				expanded = File.expand_path(path)
				# Three cases of what we are adding can arise:
				# file of the template being added
				# directory of the template being added
				# binding of the template being added
				type = File.directory?(expanded) ? :directory : (expanded.end_with?(".rb") ? :binding : :file)
				hub = (type == :binding ? :binding : :template)

				if type == :file
					# If the file we are adding is a single file,
					# make a directory and put the file in it.
					expanded_sans_extension = File.join(HUBS[hub], File.basename(expanded, ".*"))
					FileUtils.mkdir(expanded_sans_extension)
					FileUtils.copy_entry(expanded, File.join(expanded_sans_extension, File.basename(expanded)))
				elsif type == :binding
					# If we are adding a binding,
					# we need to modify the code to work with our system.
					output_file = File.open(File.join(HUBS[hub], File.basename(expanded)), "w")

					output_file.print "module Bindings\n"
					File.open(expanded, "r").each do |line|
						if line.lstrip.start_with?("class ")
							output_file.print(line + "def get_binding\nbinding\nend\n")
						else
							output_file.print line
						end
					end
					output_file.print "end\n"

					output_file.close

					# We will save the original file just in case.
					FileUtils.copy_entry(expanded, File.join(HUBS[:original], File.basename(expanded)))
				else
					FileUtils.copy_entry(expanded, File.join(HUBS[hub], File.basename(expanded)))
				end
			end

			def remove(path)
				removing_template = !path.end_with?(".rb")

				unless removing_template
					# Remove the associated binding.
					begin
						FileUtils.remove_file(File.join(HUBS[:binding], path))
						FileUtils.remove_file(File.join(HUBS[:original], path))
					rescue StandardError
						# If we failed to remove one of these files, try to remove a template by the same name.
						removing_template = true
					end
				end

				# Remove the associated template.
				FileUtils.remove_dir(File.join(HUBS[:template], path), true) if removing_template
			end

			def list
				# In our list, we want to indicate if a template does not have a corresponding binding.
				# As a result, we should list like so:
				# Template    Binding
				# example     example.rb
				Terminal::Table.new do |t|
					templates = list_templates.sort
					bindings = list_bindings.sort

					# table header
					t.add_row ["Template", "Binding"]
					t.add_separator

					templates.each do |tm|
						bind = tm + ".rb"
						bind = nil unless bindings.include?(bind)
						bindings.delete(bind) if bind

						t.add_row [tm, bind]
					end

					bindings.each do |b|
						t.add_row [nil, b]
					end
				end
			end

			def copy(path)
				if File.exist?(path)
					puts "A file of this name already exists.\nPlease remove it, or else this command will not work."
					return
				end

				# This code is very similar to that of remove.
				copying_template = !(path.end_with?(".rb") && File.exist?(File.join(HUBS[:binding], path)))

				FileUtils.copy_entry(File.join(HUBS[copying_template ? :template : :original], path), path)
			end

			def combined_list
				list_templates + list_bindings
			end

			def list_templates
				unique_directory_list(HUBS[:template])
			end

			def list_bindings
				unique_directory_list(HUBS[:binding])
			end

			def require_binding(bind)
				require File.join(HUBS[:binding], bind)
			end

			def unique_directory_list(path)
				Dir.entries(path).reject { |d| d == "." || d == ".." }
			end
		end
	end
end
