module Sinatra
  module ScriptPageHelper

    def script_page(name, hash = {})
      script_page = File.new("#{__dir__}/views/script_page.erb").read
      page_erb = ERB.new(script_page)

      script_str = File.new("#{__dir__}/views/#{name}.js").read
      script_erb = ERB.new(script_str)
      script = script_erb.result_with_hash(hash)

      result = page_erb.result(binding)
      result
    end

    def post_message(message)
      target_origin = EverEmpire::API::Config.target_origin
      script_page :post_message, message: message, target_origin: target_origin
    end
  end
end

class ERB
  def result_with_hash(hash)
    b = new_toplevel
    hash.each_pair do |key, value|
      b.local_variable_set(key, value)
    end
    result(b)
  end
end
