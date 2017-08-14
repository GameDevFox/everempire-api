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
    autoload :TokenStrategy, 'everempire/api/token_strategy'

    Warden::Strategies.add(:token, TokenStrategy)

    APP = Rack::Builder.new do
      use Rack::Session::Pool

      use Warden::Manager do |manager|
        manager.default_strategies :token
        manager.failure_app = proc { [401, {}, ['Nope... nope, nope, nope.']] }
      end

      OmniAuth.config.full_host = Config.host_name
      # TODO: Make this configurable
      OmniAuth.config.failure_raise_out_environments = []

      provider_opts = {
        developer: [
          fields: %i[uid name email],
          uid_field: :uid
        ]
      }

      use OmniAuth::Builder do
        Config.providers.each do |prov|
          if provider_opts[prov]
            provider prov, *provider_opts[prov]
          else
            provider prov, Config["auth_#{prov}_id"], Config["auth_#{prov}_secret"]
          end
        end
      end

      run Rack::Cascade.new([Application, OmniAuthCallbacks])
    end.to_app
  end
end
