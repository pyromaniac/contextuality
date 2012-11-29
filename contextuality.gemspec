# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'contextuality/version'

Gem::Specification.new do |gem|
  gem.name          = "contextuality"
  gem.version       = Contextuality::VERSION
  gem.authors       = ["pyromaniac"]
  gem.email         = ["kinwizard@gmail.com"]
  gem.description   = %q{Contextual global variables}
  gem.summary       = %q{Contextual global variables}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
