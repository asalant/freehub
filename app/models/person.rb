class Person < ActiveRecord::Base
  belongs_to :organization
  validates_presence_of :first_name, :organization_id
  #todo: validate unique shop_id, first name, last name, email
end
