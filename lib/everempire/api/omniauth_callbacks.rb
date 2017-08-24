require 'sinatra'

require 'everempire/api/db'
require 'sinatra/script_page_helper'

module EverEmpire
  module API
    class OmniAuthCallbacks < Sinatra::Base
      helpers Sinatra::ScriptPageHelper

      %w[get post].each do |method|
        send(method, '/auth/:provider/callback') do
          # Before we create this new session
          # let's clean out the old, expired tokens
          DB::Token.expired.delete

          auth_hash = env['omniauth.auth']
          auth = DB::Auth.first(provider: auth_hash.provider, provider_uid: auth_hash.uid)

          user_id = auth&.user_id || create_user(auth_hash)
          token = DB::Token.create_for_user user_id

          post_message type: :auth, token: token[:token], expires_at: token.expires_at.utc.iso8601
        end
      end

      get '/auth/failure' do
        post_message type: :auth_failure, data: env['rack.request.query_hash']
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
    end
  end
end
