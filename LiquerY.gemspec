
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "LiquerY/version"

Gem::Specification.new do |spec|
  spec.name          = "liquery"
  spec.version       = Liquery::VERSION
  spec.authors       = ["Andrew Johnson"]
  spec.email         = ["ajohnson.uva@gmail.com"]

  spec.summary       = %q{CLI app interfacing with thecocktaildb API}
  spec.description   = %q{App to offer drink recommendations for users}
  spec.homepage      = "https://github.com/aaj3f/LiquerY"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "http://mygemserver.com"
  #
  #   spec.metadata["homepage_uri"] = spec.homepage
  #   spec.metadata["source_code_uri"] = "https://rubygems.org"
  #   spec.metadata["changelog_uri"] = "https://github.com/aaj3f/LiquerY/commits/master"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end
  #
  # require_relative "../lib/LiquerY/CLI"
  # require_relative "../lib/LiquerY/drink"
  # require_relative "../lib/LiquerY/DrinkAPI"
  # require_relative "../lib/LiquerY/User"
  # require_relative "../lib/LiquerY/version"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = ['config/environment.rb', 'lib/liquery.rb', 'lib/LiquerY/CLI.rb', 'lib/LiquerY/drink', 'lib/LiquerY/DrinkAPI', 'lib/LiquerY/User', 'lib/LiquerY/version']
  spec.executables << 'liquery'
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_runtime_dependency "tty-spinner"
  spec.add_runtime_dependency "colorize"
  spec.add_runtime_dependency "fuzzy_match"


end
