# ActsAsPaginated provides Model.paginated(options={}) to allow paginated_find
# to be used with has_finder.
#
# Usage:
#   acts_as_paginated
#   acts_as_paginated :page => 2, size => 20
#
module ActsAsPaginated #:nodoc:

  def self.included(mod)
    mod.extend(ClassMethods)
  end

  module ClassMethods
    def acts_as_paginated(options={ :page => 1, :size => 10})
      cattr_accessor :paginated_defaults
      self.paginated_defaults = options
      
      self.class_eval do
        extend ActsAsPaginated::SingletonMethods
      end
    end
  end

  module SingletonMethods
    def paginated(args={})
      options = self.paginated_defaults.clone
      options[:page] = args[:page].to_i if args[:page]
      options[:size] = args[:size].to_i if args[:size]
      find(:all, :page => { :size => options[:size], :current => options[:page], :first => 1 })
    end
  end
end

ActiveRecord::Base.send(:include, ActsAsPaginated)