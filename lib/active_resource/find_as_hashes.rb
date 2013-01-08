require "find_as_hashes/version"
require 'active_resource'

module ActiveResource
  class Base
    class << self
      def find_as_hashes(*args)
        @skip_instantiate = true
        find(*args)
      end

      def all_as_hashes(*args)
        find_as_hashes(:all, *args)
      end

      def first_as_hash(*args)
        find_as_hashes(:first, *args)
      end

      def last_as_hash(*args)
        find_as_hashes(:last, *args)
      end

      def instantiate_collection_with_check(collection, prefix_options = {})
        if @skip_instantiate
          @skip_instantiate = nil
          collection
        else
          instantiate_collection_without_check(collection, prefix_options)
        end
      end
      
      alias_method :instantiate_collection_without_check, :instantiate_collection
      alias_method :instantiate_collection, :instantiate_collection_with_check
    end
  end
end
