module EverEmpire
  module API
    class ApiStrategy < Warden::Strategies::Base
      def valid?
        env['HTTP_API_TOKEN']
      end

      def authenticate!
        api_token = env['HTTP_API_TOKEN']
        return unless api_tokens.include? api_token

        as_user = env['HTTP_AS_USER']
        user_id = as_user || 0

        success!(user_id)
      end

      def store?
        false
      end

      def api_tokens
        @api_tokens ||= Config.api_tokens.split(',')
      end
    end
  end
end
