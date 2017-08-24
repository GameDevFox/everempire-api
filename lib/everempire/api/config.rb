module EverEmpire
  module API
    module Config
      PREFIX = 'EVEREMPIRE_'.freeze

      def self.[](name)
        var_name = PREFIX + name.upcase
        raise "Environment variable #{var_name} is not set" unless ENV[var_name]
        ENV[var_name]
      end

      def self.concurrent_token_limit
        2
      end

      def self.expire_token_interval_secs
        @expire_token_interval_secs ||= self['expire_token_interval_secs'].to_i
      end

      def self.providers
        @providers ||= self['auth_providers'].split(',').map &:to_sym
      end

      def respond_to_missing?
        true
      end

      def self.method_missing(sym)
        self[sym.to_s]
      end
    end
  end
end
