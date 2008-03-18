module Freehub
  module Userstamp
  
    def self.included(mod)
      mod.extend(ClassMethods)
    end

    module ClassMethods
      def has_userstamps
        belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
        belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"
      end
    end
  end
end

ActiveRecord::Base.send(:include, Freehub::Userstamp)