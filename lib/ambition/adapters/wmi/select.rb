##
# The format of the documentation herein is:
#
# >> method with block
# => methods on this class called by Ambition (with arguments)
#
module Ambition
  module Adapters
    module WMI
      class Select < Base
        # >> select { |u| u.name == 'chris' }
        # => #call(:name)
        def call(method)
          method
        end

        # >> select { |u| u.name.downcase == 'chris' }
        # => #call(:name, :downcase)
        def chained_call(*methods)
          # An idiom here is to call the chained method and pass it
          # the first method.
          #
          #   if respond_to? methods[1]
          #     send(methods[1], methods[0])
          #   end
          #
          # In the above example, this translates to calling:
          #
          #   #downcase(:name)
          #
          raise "Not implemented."
        end

        def both(left, right)
          "(#{left} AND #{right})"
        end

        def either(left, right)
          "(#{left} OR #{right})"
        end

        def ==(left, right)
          if right.nil?
            "#{left} IS NULL"
          else
            "#{left} = #{sanitize right}"
          end
        end

        # !=
        def not_equal(left, right)
          if right.nil?
            "#{left} IS NOT NULL"
          else
            "#{left} <> #{sanitize right}"
          end
        end

        def =~(left, right)
          if right.is_a? Regexp
            "#{left} #{statement(:regexp, right)} #{sanitize right}"
          else
            "#{left} LIKE #{sanitize right}"
          end
        end

        # !~
        def not_regexp(left, right)
          if right.is_a? Regexp
            "#{left} #{statement(:not_regexp, right)} #{sanitize right}"
          else
            "#{left} NOT LIKE #{sanitize right}"
          end
        end

        def <(left, right)
          "#{left} < #{sanitize right}"
        end

        def >(left, right)
          "#{left} > #{sanitize right}"
        end

        def >=(left, right)
          "#{left} >= #{sanitize right}"
        end

        def <=(left, right)
          "#{left} <= #{sanitize right}"
        end

        def include?(left, right)
          if left.is_a? Range
            op = left.exclude_end? ? :< : :<=
            both(self.>=(right, left.first), self.send(op, right, left.last))
          else
            left = left.map { |element| sanitize element }.join(', ')
            "#{right} IN (#{left})"
          end
        end

        def nil?(column)
          left = "#{owner.subclass_name}.#{quote_column_name column}"
          negated? ? not_equal(left, nil) : self.==(left, nil)
        end

        #~ def downcase(column)
          #~ "LOWER(#{owner.subclass_name}.#{quote_column_name column})"
        #~ end

        #~ def upcase(column)
          #~ "UPPER(#{owner.subclass_name}.#{quote_column_name column})"
        #~ end
      end
    end
  end
end
