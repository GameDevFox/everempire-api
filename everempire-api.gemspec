# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'everempire/api/version'

Gem::Specification.new do |spec|
  spec.name          = 'everempire-api'
  spec.version       = EverEmpire::API::VERSION
  spec.authors       = ['Edward Nicholes Jr.']
  spec.email         = ['GameDevFox@gmail.com']

  spec.summary       = 'EverEmpire API'
  spec.description   = 'Serves as the back end service for EverEmpire'
  spec.homepage      = 'https://github.com/GameDevFox/everempire-api'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
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

  spec.add_runtime_dependency 'grape', '~> 1.0.0'
  spec.add_runtime_dependency 'omniauth', '~> 1.6.1'
  spec.add_runtime_dependency 'omniauth-facebook', '~> 4.0.0'
  spec.add_runtime_dependency 'omniauth-github', '~> 1.3.0'
  spec.add_runtime_dependency 'omniauth-google-oauth2', '~> 0.5.2'
  spec.add_runtime_dependency 'omniauth-twitter', '~> 1.4.0'
  spec.add_runtime_dependency 'pg', '~> 0.21.0'
  spec.add_runtime_dependency 'rack', '~> 2.0.3'
  spec.add_runtime_dependency 'sequel', '~> 4.49.0'
  spec.add_runtime_dependency 'sinatra', '~> 2.0.0'
  spec.add_runtime_dependency 'warden', '~> 1.2.7'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'pry-byebug', '~> 3.4.2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
