require "find_as_hashes/version"
require 'active_record'
require 'active_support/core_ext'

module FindAsHashes

  module Relation
    def all_as_hashes
      connection.select_all(self.joins(self.includes_values).to_sql)
    end

    def first_as_hash
      relation_stack = limit(1)
      connection.select_one(relation_stack.joins(relation_stack.includes_values).to_sql)
    end
  end

  module Base
    delegate :all_as_hashes, :first_as_hash, :to => :scoped
  end

end

ActiveRecord::Relation.send :include, FindAsHashes::Relation
ActiveRecord::Base.extend FindAsHashes::Base
