require 'everempire/api/version'

require 'omniauth'
require 'omniauth-facebook'
require 'omniauth-github'
require 'omniauth-google-oauth2'
require 'omniauth-twitter'
require 'rack'

module EverEmpire
  module API
    autoload :BaseAPI, 'everempire/api/base_api'
    autoload :DB, 'everempire/api/db'
    autoload :OmniAuthCallbacks, 'everempire/api/omniauth_callbacks'
    autoload :Config, 'everempire/api/config'

    config = Config

    APP = Rack::Builder.new do |builder|
      use Rack::Session::Pool

      OmniAuth.config.full_host = config.host_name
      # TODO: Make this configurable
      OmniAuth.config.failure_raise_out_environments = []

      provider_opts = {
        developer: [
          fields: %i[uid name email],
          uid_field: :uid
        ]
      }

      use OmniAuth::Builder do
        config.providers.each do |prov|
          if provider_opts[prov]
            provider prov, *provider_opts[prov]
          else
            provider prov, config["auth_#{prov}_id"], config["auth_#{prov}_secret"]
          end
        end
      end

      run Rack::Cascade.new([BaseAPI, OmniAuthCallbacks])
    end.to_app
  end
end
