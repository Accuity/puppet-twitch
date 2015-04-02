# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'puppet_twitch/version'

excude = ['.gitignore', 'Rakefile', 'puppet/.*', 'nodes.json', 'Vagrantfile']

Gem::Specification.new do |gem|
  gem.name          = 'puppet-twitch'
  gem.version       = PuppetTwitch::VERSION
  gem.description   = 'Trigger a puppet run remotely'
  gem.summary       = 'http trigger for puppet'
  gem.author        = 'Tom Poulton'
  gem.license       = 'MIT'
  gem.homepage      = 'http://github.com/Accuity/puppet-twitch'

  gem.files         = `git ls-files`.split($/).reject { |file| file =~ /^(#{excude.join('|')})$/ }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency('daemons', '~> 1.2.2')
end
