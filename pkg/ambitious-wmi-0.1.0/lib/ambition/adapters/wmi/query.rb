=begin

These methods are king:

  - owner
  - clauses
  - stash

+owner+ is the class from which the request was generated.

User.select { |u| u.name == 'Pork' }
# => owner == User

+clauses+ is the hash of translated arrays, keyed by processors

User.select { |u| u.name == 'Pork' }
# => clauses ==  { :select => [ "users.name = 'Pork'" ] }

+stash+ is your personal private stash.  A hash you can use for
keeping stuff around.

User.select { |u| u.profile.name == 'Pork' }
# => stash == { :include => [ :profile ] }

The above is totally arbitrary.  It's basically a way for your
translators to talk to each other and, more importantly, to the Query
object.

=end
module Ambition
  module Adapters
    module WMI
      class Query < Base
        @@select = 'SELECT * FROM %s %s'

        def kick
          owner.find(:all, to_hash)
        end

        def size
          owner.count(to_hash)
        end

        def to_hash
          hash = {}

          unless (where = clauses[:select]).blank?
            hash[:conditions] = Array(where)
            hash[:conditions] *= ' AND '
          end

          if order = clauses[:sort]
            hash[:order] = order.join(', ')
          end

          if Array(clauses[:slice]).last =~ /LIMIT (\d+)/
            hash[:limit] = $1.to_i
          end

          if Array(clauses[:slice]).last =~ /OFFSET (\d+)/
            hash[:offset] = $1.to_i
          end

          hash[:include] = stash[:include] if stash[:include]

          hash
        end

        def to_s
          hash = to_hash

          raise "Sorry, I can't construct WQL with complex joins (yet)" unless hash[:include].blank?

          sql = []
          sql << "WHERE #{hash[:conditions]}" unless hash[:conditions].blank?
          sql << "ORDER BY #{hash[:order]}"   unless hash[:order].blank?
          sql << clauses[:slice].last         unless hash[:slice].blank?

          @@select % [ owner.subclass_name, sql.join(' ') ]
        end
        alias_method :to_wql, :to_s
      end
    end
  end
end
