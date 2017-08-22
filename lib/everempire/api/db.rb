require 'sequel'

module EverEmpire
  module API
    module DB
      Sequel::Model.plugin :json_serializer

      DB = Sequel.connect(EverEmpire::API::Config.db_url)
      # DB.extension :pg_interval

      class Auth < Sequel::Model(DB[:auth]); end

      class Token < Sequel::Model(DB[:token])
        @expire_token_interval_secs = Config.expire_token_interval_secs

        def self.active
          where(Sequel.lit('created_at + INTERVAL ? > NOW()', "#{@expire_token_interval_secs} seconds"))
        end

        def self.expired
          where(Sequel.lit('created_at + INTERVAL ? <= NOW()', "#{@expire_token_interval_secs} seconds"))
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
