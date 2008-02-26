class Report < ActiveRecord::Base
  attr_accessor_with_default :scope, :session
end
