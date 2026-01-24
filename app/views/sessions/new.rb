# frozen_string_literal: true

module Views
  module Sessions
    class New < Views::Base
      include Phlex::Rails::Helpers::FormWith

      def page_title = 'Sign In'
      def layout = Layout

      def view_template
        form_with url: session_path, builder: BulmaPhlex::Rails::FormBuilder do |form|
          form.email_field :email_address,
                           required: true,
                           autofocus: true,
                           autocomplete: 'username',
                           placeholder: 'Enter your email address',
                           icon_left: 'fas fa-at'
          form.password_field :password,
                              required: true,
                              autocomplete: 'current-password',
                              maxlength: 72,
                              icon_left: 'fas fa-lock'
          form.button 'Sign in', class: 'button'
        end
      end
    end
  end
end
