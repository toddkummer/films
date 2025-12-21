# frozen_string_literal: true

module Components
  # Base class for Phlex components.
  class Base < Phlex::HTML
    extend Literal::Properties

    include Phlex::Rails::Helpers::DOMID
    include Phlex::Rails::Helpers::Routes

    if Rails.env.development?
      def before_template
        comment { "Before #{self.class.name}" }
        super
      end
    end
  end
end
