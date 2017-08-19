module EverEmpire
  module API
    module OmniAuthProviders
      def self.use(builder)
        OmniAuth.config.full_host = Config.host_name

        provider_opts = {
          developer: [
            fields: %i[uid name email],
            uid_field: :uid
          ]
        }

        builder.use OmniAuth::Builder do
          Config.providers.each do |prov|
            if provider_opts[prov]
              provider prov, *provider_opts[prov]
            else
              provider prov, Config["auth_#{prov}_id"], Config["auth_#{prov}_secret"]
            end
          end
        end
      end
    end
  end
end
