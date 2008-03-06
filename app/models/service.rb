class Service < ActiveRecord::Base
  belongs_to :service_type
  belongs_to :person

  validates_presence_of :person_id, :service_type_id
  
  acts_as_paginated
end
