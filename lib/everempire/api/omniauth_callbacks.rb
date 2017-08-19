require 'sinatra'

require 'everempire/api/db'
require 'sinatra/script_page_helper'

module EverEmpire
  module API
    class OmniAuthCallbacks < Sinatra::Base
      helpers Sinatra::ScriptPageHelper

      %w[get post].each do |method|
        send(method, '/auth/:provider/callback') do
          auth_hash = env['omniauth.auth']

          auth = DB::Auth.first(
            provider: auth_hash.provider,
            provider_uid: auth_hash.uid
          )

          user_id = auth&.user_id || create_user(auth_hash)
          token = create_token user_id

          event_page :auth, token
        end
      end

      get '/auth/failure' do
        event_page :auth_failure, env['rack.request.query_hash']
      end

      private
      def create_user(auth_hash)
        user = DB::User.create(
          name: auth_hash.info.nickname || auth_hash.info.name,
          email: auth_hash.info.email
        )

        DB::Auth.create(
          provider: auth_hash.provider,
          provider_uid: auth_hash.uid,
          user_id: user.id,
          created_at: Sequel.function(:NOW)
        )

        user.id
      end

      def create_token(user_id)
        token_str = SecureRandom.hex(32)

        if DB::Token.first(user_id: user_id)
          # update existing token
          DB::Token.where(user_id: user_id).update(token: token_str, created_at: Sequel.function(:now))
        else
          # create token
          DB::Token.create(user_id: user_id, token: token_str, created_at: Sequel.function(:now))
        end

        token_str
      end
    end
  end
end
