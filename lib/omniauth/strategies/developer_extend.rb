module OmniAuth
  module Strategies

    class Developer
      def request_phase
        form = OmniAuth::Form.new(title: 'User Info', url: callback_url)
        options.fields.each do |field|
          form.text_field field.to_s.capitalize.tr('_', ' '), field.to_s
        end
        form.button 'Sign In'
        form.to_response
      end

      def callback_url
        script_name + callback_path
      end
    end

  end
end
