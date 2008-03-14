class Service < ActiveRecord::Base
  belongs_to :person

  validates_presence_of :person_id, :service_type_id
  
  acts_as_paginated
  chains_finders

  has_finder :for_organization, lambda { |organization| {
      :conditions => [ "services.person_id in (select people.id from people where people.organization_id = ?)", organization ],
      :include => [ :person ],
      :order => 'end_date DESC'
  } }

  has_finder :after, lambda { |date| {
      :conditions => [ "services.start_date >= ?", date ]
  } }

  has_finder :before, lambda { |date| {
      :conditions => [ "services.end_date <= ?", date ]
  } }

  has_finder :for_service_types, lambda { |service_types| {
      :conditions => [ "services.service_type_id IN (?)", service_types ]
      #:conditions => [ "services.service_type_id IN (?)", service_types.collect{|type| "'#{type}"}.join(',') ]
  } }

  def service_type
    ServiceType[service_type_id]
  end

  CSV_FIELDS = { :person => %w{first_name last_name email phone postal_code},
                 :self => %w{service_type_id start_date end_date volunteered paid note} }
  def to_csv
    values = person.attributes.values_at(*CSV_FIELDS[:person])
    values << service_type_id
    values << start_date ? nil : start_date.to_s(:db)
    values << end_date ? nil : end_date.to_s(:db)
    values << volunteered
    values << paid
    values << note
    CSV.generate_line values
  end
end
