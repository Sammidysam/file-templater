module FileTemplater
	class FileActions
		class << self
			def create_hub_if_necessary
				HUBS.each do |k, v|
					Dir.mkdir(v) unless Dir.exists?(v)
				end
			end

			def add_template(path)
				expanded = File.expand_path(path)
				FileUtils.copy_entry(expanded, File.join(HUBS[:template], File.basename(expanded)))
			end

			# Consider securing this to only delete items in the template hub.
			def remove_template(path)
				FileUtils.remove_dir(File.join(HUBS[:template], path))
			end

			def list_templates
				unique_directory_list(HUBS[:template])
			end

			def list_bindings
				unique_directory_list(HUBS[:binding])
			end

			private
			def unique_directory_list(path)
				Dir.entries(path).reject { |d| d == "." || d == ".." }
			end
		end
	end
end
