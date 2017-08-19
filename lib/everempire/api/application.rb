require 'grape'

module EverEmpire
  module API
    class Application < Grape::API
      default_format :json

      module RawJson
        def to_json
          self
        end
      end

      helpers do
        def raw_json(result)
          result.extend(RawJson)
        end

        def token
          env['HTTP_TOKEN']
        end

        def user_id
          env['warden'].authenticate!
        end
      end

      get '/auth/providers' do
        Config.providers
      end

      get '/worlds' do
        raw_json DB::World.eager(:user).to_json(include: :user)
      end

      get '/me' do
        DB::User[user_id]
      end

      delete '/me/token' do
        DB::Token.first(user_id: user_id, token: token).delete
        body false
      end

      get '/me/worlds' do
        DB::World.where(user_id: user_id)
      end

      post '/me/world' do
        raw_json DB::World.create(name: params['name'], user_id: user_id).to_json(include: :user)
      end

      delete '/me/world/:id' do
        user_id = env['warden'].authenticate!

        DB::World.first(id: params[:id], user_id: user_id).delete
        body false
      end
    end
  end
end
