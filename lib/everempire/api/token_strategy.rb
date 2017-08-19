module EverEmpire
  module API
    class TokenStrategy < Warden::Strategies::Base
      def valid?
        env['HTTP_TOKEN']
      end

      def authenticate!
        token = env['HTTP_TOKEN']
        user_id = token_dataset.first(token: token)&.user_id

        if user_id
          success!(user_id)
        else
          fail!
        end
      end

      def store?
        false
      end

      def token_dataset
        @token_dataset ||= DB::Token.where(
          Sequel.lit("created_at + INTERVAL '5 minutes' > NOW()")
        )
      end
    end
  end
end
