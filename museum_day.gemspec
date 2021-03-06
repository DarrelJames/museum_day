lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "museum_day/version"

Gem::Specification.new do |spec|
  spec.name          = "museum_day"
  spec.version       = MuseumDay::VERSION
  spec.authors       = ["Darrel Castellano"]
  spec.email         = ["dcastellano2007@gmail.com"]

  spec.summary       = "Museums in your area"
  spec.description   = "View participating Museum Day ticket holders in your area. View details about the museum"
  spec.homepage      = "https://rubygems.org/gems/museum_day"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  #
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/DarrelJames/museum_day"


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = ["museum_day"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"

  spec.add_dependency "nokogiri"

end
