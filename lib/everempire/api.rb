require 'everempire/api/version'

require 'omniauth'
require 'omniauth-facebook'
require 'omniauth-github'
require 'omniauth-google-oauth2'
require 'omniauth-twitter'

require 'rack'
require 'warden'

module EverEmpire
  module API
    autoload :Application, 'everempire/api/application'
    autoload :Config, 'everempire/api/config'
    autoload :DB, 'everempire/api/db'
    autoload :OmniAuthCallbacks, 'everempire/api/omniauth_callbacks'
    autoload :OmniAuthProviders, 'everempire/api/omniauth_providers'
    autoload :TokenStrategy, 'everempire/api/token_strategy'

    Warden::Strategies.add(:token, TokenStrategy)

    APP = Rack::Builder.new do |builder|
      use Rack::Session::Pool

      use Warden::Manager do |manager|
        manager.default_strategies :token
        manager.failure_app = proc { [401, {}, ['Nope... nope, nope, nope.']] }
      end

      OmniAuthProviders.use(builder)

      run Rack::Cascade.new([Application, OmniAuthCallbacks])
    end.to_app
  end
end
