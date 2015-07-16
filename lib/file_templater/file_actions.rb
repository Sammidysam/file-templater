module FileTemplater
	class FileActions
		class << self
			def create_hub_if_necessary
				HUBS.each do |k, v|
					Dir.mkdir(v) unless Dir.exists?(v)
				end
			end

			def add(path, hub)
				expanded = File.expand_path(path)
				FileUtils.copy_entry(expanded, File.join(HUBS[hub], File.basename(expanded)))
			end

			def remove(path)
				# Remove the associated template.
				FileUtils.remove_dir(File.join(HUBS[:template], path), true)

				# Remove the associated binding.
				FileUtils.remove_file(File.join(HUBS[:binding], path + ".rb"), true)
			end

			def list
				# In our list, we want to indicate if a template does not have a corresponding binding.
				# As a result, we should list like so:
				# Template    Binding
				# example     example.rb
				Terminal::Table.new do |t|
					templates = list_templates
					bindings = list_bindings

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

			def list_templates
				unique_directory_list(HUBS[:template])
			end

			def list_bindings
				unique_directory_list(HUBS[:binding])
			end

			# Requires all of the .rb files in HUBS[:binding].
			def require_all_bindings
				unique_directory_list(HUBS[:binding]).each do |f|
					if f.end_with?(".rb")
						require File.join(HUBS[:binding], f.chomp(".rb"))
					end
				end
			end

			private
			def unique_directory_list(path)
				Dir.entries(path).reject { |d| d == "." || d == ".." }
			end
		end
	end
end
