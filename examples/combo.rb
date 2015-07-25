class Combo
	def initialize(tune, composer = nil, arranger = nil)
		@tune = tune
		clean_tune = tune.gsub(/[^(A-z| )]/, "")
		@variable_prefix = clean_tune.downcase.split(" ").map { |w| w.capitalize }.join
		@variable_prefix[0] = @variable_prefix[0].downcase
		@filename = clean_tune.downcase.split(" ").join("-")

		@composer = composer
		@arranger = arranger

		@version = lilypond_version
	end

	def lilypond_version
		# Get the lilypond version text.
		text = `lilypond --version`

		# The version number is on the first line, after "GNU LilyPond".
		version_line = text.lines.first

		# Conveniently, it is also the last word.
		version_line.split(" ").last
	end
end
