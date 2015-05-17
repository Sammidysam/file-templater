module FileTemplater
	class FileActions
		class << self
			def create_hub_if_necessary
				Dir.mkdir(HUB) unless Dir.exists?(HUB)
				Dir.mkdir(TEMPLATE_HUB) unless Dir.exists?(TEMPLATE_HUB)
				Dir.mkdir(BINDINGS_HUB) unless Dir.exists?(BINDINGS_HUB)
			end

			def add_template(path)
				expanded = File.expand_path(path)
				FileUtils.copy_entry(expanded, File.join(HUBS[:template], File.basename(expanded)))
			end
		end
	end
end
