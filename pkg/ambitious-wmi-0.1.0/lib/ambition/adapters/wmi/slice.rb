module Ambition
  module Adapters
    module WMI
      class Slice < Base
        # >> User.first(5)
        # => #slice(0, 5)
        #
        # >> User.first
        # => #slice(0, 1)
        #
        # >> User[10, 20]
        # => #slice(10, 20)
        def slice(start, length=nil)
          if start.is_a? Range
            length  = start.end
            length -= 1 if start.exclude_end?
            start = start.first - 1
            length -= start
          end
          out  = "LIMIT #{length} "
          out << "OFFSET #{start}" if start.to_i.nonzero?
          out
        end
      end
    end
  end
end
