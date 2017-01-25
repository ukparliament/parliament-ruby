# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parliament/version'

Gem::Specification.new do |spec|
  spec.name          = 'parliament'
  spec.version       = Parliament::VERSION
  spec.authors       = ['Matt Rayner']
  spec.email         = ['mattrayner1@gmail.com']
  spec.summary       = %q{Internal parliamentary data API wrapper for ruby}
  spec.description   = %q{Internal parliamentary data API wrapper for ruby}
  spec.homepage      = 'http://github.com/ukparliament/parliament_ruby'
  spec.license       = 'Open Parliament License'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'TODO: Set to \'http://mygemserver.com\''
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'grom', '~> 0.2.0'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.47.1'
  spec.add_development_dependency 'pry', '~> 0.10.4'
  spec.add_development_dependency 'pry-nav', '~> 0.2.4'
  spec.add_development_dependency 'simplecov', '~> 0.12.0'
  spec.add_development_dependency 'vcr', '~> 3.0.3'
  spec.add_development_dependency 'webmock', '~> 2.3.2'
end
