require 'sequel'

module EverEmpire
  module API
    module DB
      Sequel::Model.plugin :json_serializer
      db = Sequel.connect(EverEmpire::API::Config.db_url)

      class Auth < Sequel::Model(db[:auth]); end
      class Token < Sequel::Model(db[:token]); end
      class User < Sequel::Model(db[:user]); end
      class World < Sequel::Model(db[:world]); end
    end
  end
end
