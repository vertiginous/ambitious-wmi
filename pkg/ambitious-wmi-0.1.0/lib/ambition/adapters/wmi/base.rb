module Ambition
  module Adapters
    module WMI
      class Base

        def sanitize(value)
          if value.is_a? Array
            return value.map { |v| sanitize(v) }.join(', ')
          end

          case value
          when true,  'true'
            '1'
          when false, 'false'
            '0'
          when Regexp
            "'#{value.source}'"
          else
            if active_connection?
              ::ActiveRecord::Base.connection.quote(value)
            else
              quote(value)
            end
          end
        rescue
          "'#{value}'"
        end

        def quote_column_name(value)
          value.to_s
        end
        ##
        # Extract common functionality into this class.
        # All your classes, by default, inherit from this
        # one -- Query and the Translators.
      end
    end
  end
end
