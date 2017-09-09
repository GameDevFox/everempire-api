require 'everempire/api/version'

require 'omniauth'
require 'omniauth-facebook'
require 'omniauth-github'
require 'omniauth-google-oauth2'
require 'omniauth-twitter'

require 'rack'
require 'rack/cors'
require 'warden'

require 'omniauth/strategies/developer_extend'

module EverEmpire
  module API
    autoload :ApiStrategy, 'everempire/api/api_strategy'
    autoload :Application, 'everempire/api/application'
    autoload :Config, 'everempire/api/config'
    autoload :DB, 'everempire/api/db'
    autoload :OmniAuthCallbacks, 'everempire/api/omniauth_callbacks'
    autoload :OmniAuthProviders, 'everempire/api/omniauth_providers'
    autoload :TokenStrategy, 'everempire/api/token_strategy'

    APP = Rack::Builder.new do |builder|
      if ENV['RACK_ENV'] == 'development'
        puts 'Using CORS middleware [development mode]'
        use Rack::Cors do
          allow do
            origins '*'
            resource '*', headers: :any, methods: %i[get post put delete options]
          end
        end
      end

      use Rack::Session::Pool

      Warden::Strategies.add(:token, TokenStrategy)
      Warden::Strategies.add(:api, ApiStrategy)

      use Warden::Manager do |manager|
        manager.default_strategies :token, :api
        manager.failure_app = proc { [401, { 'Content-Type' => 'text/plain' }, ['Nope...']] }
      end

      OmniAuthProviders.use(builder)

      run Rack::Cascade.new([Application, OmniAuthCallbacks])
    end.to_app
  end
end
