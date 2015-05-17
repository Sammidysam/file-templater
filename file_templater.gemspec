# Allowing clean local running.
lib_directory = File.expand_path(File.join(File.dirname(__FILE__), "lib"))
$LOAD_PATH.unshift(lib_directory) unless $LOAD_PATH.map { |directory| File.expand_path(directory) }.include?(lib_directory)

require "file_templater/variables"

Gem::Specification.new do |s|
    s.name = "file_templater"
    s.email = "sammidysam@gmail.com"
    s.version = FileTemplater::VERSION
    s.license = "gpl-3.0"
    s.summary = "A simple system to create files/file structures from ERB templates."
    s.author = "Sam Craig"
    s.homepage = "https://github.com/Sammidysam/file_templater"
    s.files = Dir.glob("lib/**/*.rb") << "bin/template"
    s.executables << "template"
end
