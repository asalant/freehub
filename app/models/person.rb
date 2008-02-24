class Person < ActiveRecord::Base
  belongs_to :organization
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"
  
  validates_presence_of :first_name, :organization_id
  #todo: validate unique shop_id, first name, last name, email
end
