
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hibinium/version"

Gem::Specification.new do |spec|
  spec.name          = "hibinium"
  spec.version       = Hibinium::VERSION
  spec.authors       = ["arikawa"]
  spec.email         = ["arikawa@i3-systems.com"]

  spec.summary       = %q{HIBIFO auto operation gem library.}
  spec.description   = %q{It is HIBIFO operation.}
  spec.homepage      = "https://bitbucket.org/arikawa-i3/hibinium/src/master/"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"
  else
    # raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'selenium-webdriver', '3.13.0'
  spec.add_dependency 'page-object', '2.2.4'
  spec.add_dependency 'thor', '0.20.0'
  spec.add_dependency 'highline', '2.0.0'
  spec.add_dependency 'awesome_print', '1.8.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
