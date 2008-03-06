class Service < ActiveRecord::Base
  belongs_to :service_type
  belongs_to :person
end
