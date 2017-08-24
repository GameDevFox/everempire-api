require 'sequel'

module EverEmpire
  module API
    module DB
      Sequel::Model.plugin :json_serializer

      DB = Sequel.connect(EverEmpire::API::Config.db_url)
      # DB.extension :pg_interval

      class Auth < Sequel::Model(DB[:auth]); end

      class Token < Sequel::Model(DB[:token])
        @expire_token_interval = "#{Config.expire_token_interval_secs} seconds"

        def self.active
          where(Sequel.lit('created_at + INTERVAL ? > NOW()', @expire_token_interval))
        end

        def self.expired
          where(Sequel.lit('created_at + INTERVAL ? <= NOW()', @expire_token_interval))
        end

        def self.create_for_user(user_id)
          # Create token
          token_str = SecureRandom.hex(32)
          token = create(user_id: user_id, token: token_str, created_at: Sequel.function(:now))

          delete_extra_tokens(user_id, Config.concurrent_token_limit)

          token
        end

        def expires_at
          self[:created_at] + Config.expire_token_interval_secs
        end

        def self.delete_extra_tokens(user_id, keep_count)
          most_recent_tokens = where(user_id: user_id).reverse_order(:created_at).limit(keep_count)
          where(user_id: user_id).exclude(id: most_recent_tokens.select(:id)).delete
        end
      end

      class User < Sequel::Model(DB[:user])
        one_to_many :world
      end

      class World < Sequel::Model(DB[:world])
        many_to_one :user
      end
    end
  end
end
