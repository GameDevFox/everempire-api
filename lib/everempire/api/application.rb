require 'grape'

module EverEmpire
  module API
    class Application < Grape::API
      format :json

      get '/test' do
        %w[hello world]
      end

      get '/me/worlds' do
        user_id = env['warden'].authenticate!
        DB::World.where(user_id: user_id)
      end

      get '/worlds' do
        DB::World.all
      end
    end
  end
end
