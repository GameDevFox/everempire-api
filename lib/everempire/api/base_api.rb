require 'grape'

module EverEmpire
  module API
    class BaseAPI < Grape::API
      format :json

      get '/auth/providers' do
        # TODO: Fix this
        auth_providers
      end

      get '/test' do
        ['hello', 'world']
      end

      get '/session' do
        Rack::Request.new(env).session.to_h
      end

      get '/me/worlds' do
        # authenticate
        token_str = env['HTTP_TOKEN']
        token = DB::Token.first(token: token_str)
        error!('401 Unauthorized', 401) unless token

        DB::World.where(user_id: token.user_id)
      end

      get '/worlds' do
        DB::World.all
      end
    end
  end
end
