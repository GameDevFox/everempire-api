module EverEmpire
  module API
    class TokenStrategy < Warden::Strategies::Base
      def valid?
        env['HTTP_TOKEN']
      end

      def authenticate!
        token = env['HTTP_TOKEN']

        user_id = DB::Token.active.first(token: token)&.user_id

        if user_id
          success!(user_id)
        else
          fail!
        end
      end

      def store?
        false
      end
    end
  end
end
