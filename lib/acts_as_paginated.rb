# Provides Model.paginate(options={}) to allow
# the paginating_find plugin to be used with the has_finder plugin.
#
# Usage:
#   acts_as_paginated
#   acts_as_paginated :page => 2, size => 10
#
module HasFinder
  module PaginatingFind #:nodoc:

    def self.included(mod)
      mod.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_paginated(options={ :page => 1, :size => 20})
        cattr_accessor :paginate_defaults
        self.paginate_defaults = options

        self.class_eval do
          extend HasFinder::PaginatingFind::SingletonMethods
        end
      end
    end

    module SingletonMethods
      def paginate(args={})
        options = self.paginate_defaults.clone
        options[:page] = args[:page].to_i if args[:page]
        options[:size] = args[:size].to_i if args[:size]
        find(:all, :page => { :size => options[:size], :current => options[:page], :first => 1 })
      end
    end
  end
end

ActiveRecord::Base.send(:include, HasFinder::PaginatingFind)