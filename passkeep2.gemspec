# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'passkeep2/version'

Gem::Specification.new do |gem|
  gem.name          = "passkeep2"
  gem.version       = Passkeep2::VERSION
  gem.summary       = %q{Password manager.}
  gem.description   = %q{Passkeep2 is a convenient CLI for keeping passwords.}
  gem.license       = "MIT"
  gem.authors       = ["aarnwri"]
  gem.email         = "aarnwri@gmail.com"
  gem.homepage      = "https://rubygems.org/gems/passkeep2"

  gem.files         = Dir['CHANGELOG.md', 'README.md', 'LICENSE.txt', 'lib/**/*']

  gem.executables   = Dir['bin/**/*'].map{ |f| File.basename(f) }
  gem.test_files    = Dir['spec/**/*']
  gem.require_paths = ['lib']

  gem.add_dependency 'trollop', '~> 2.1', '>= 2.1.2'
  gem.add_dependency 'clipboard', '~> 1.1', '>= 1.1.1'

  gem.add_development_dependency 'bundler', '~> 1.10'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'yard', '~> 0.8'
end
