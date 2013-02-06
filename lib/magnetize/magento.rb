module Magnetize
  class Magento
    OPTIONS = %w(
      administrator_given_name
      administrator_surname
      administrator_email
      administrator_username
      administrator_password
      database_name
      database_hostname
      database_username
      database_password
      database_table_prefix
    )

    def method_missing(method_name)
      option = method_name.to_s

      if OPTIONS.include? option
        self.class.class_eval do
          define_method method_name do
            ENV["magento_#{method_name}"]
          end
        end

        send method_name
      else
        super
      end
    end
  end
end
