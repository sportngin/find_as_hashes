require "find_as_hashes/version"
require 'active_record'
require 'active_support/core_ext'

module FindAsHashes

  module Relation
    def all_as_hashes
      fix_prepared_statement do
        connection.select_all(self.joins(self.includes_values).to_sql).to_a
      end
    end

    def first_as_hash
      fix_prepared_statement do
        relation_stack = limit(1)
        connection.select_one(relation_stack.joins(relation_stack.includes_values).to_sql)
      end
    end

    def fix_prepared_statement
      if connection.respond_to?(:unprepared_statement)
        connection.unprepared_statement{ yield }
      else
        yield
      end
    end
    private :fix_prepared_statement
  end

  module Base
    if ActiveRecord::VERSION::MAJOR >= 4
      delegate :all_as_hashes, :first_as_hash, :to => :all
    else
      delegate :all_as_hashes, :first_as_hash, :to => :scoped
    end
  end
end

ActiveRecord::Relation.send :include, FindAsHashes::Relation
ActiveRecord::Base.extend FindAsHashes::Base
