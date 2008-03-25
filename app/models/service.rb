class Service < ActiveRecord::Base
  tz_time_attributes :created_at, :updated_at
  
  belongs_to :person
  has_one :note, :as => :notable, :dependent => :destroy
  has_userstamps

  validates_presence_of :person_id, :service_type_id
  
  acts_as_paginated
  chains_finders

  has_finder :for_organization, lambda { |organization| {
      :conditions => [ "people.organization_id = ?", organization ],
      :include => [ :person, :note ],
      :order => 'services.end_date DESC'
  } }

  has_finder :after, lambda { |date| {
      :conditions => [ "services.end_date >= ?", date ]
  } }

  has_finder :before, lambda { |date| {
      :conditions => [ "services.start_date < ?", date ]
  } }

  has_finder :for_service_types, lambda { |service_types| {
      :conditions => [ "services.service_type_id IN (?)", service_types ]
  } }

  def initialize(params={})
    super
    self.start_date ||= Date.today
    self.end_date ||= Date.today.next_year
  end

  def current?
    (start_date.nil? || Date.today >= start_date) && (end_date.nil? || Date.today <= end_date)
  end

  def service_type
    ServiceType[service_type_id]
  end

  CSV_FIELDS = { :person => %w{first_name last_name email email_opt_out phone postal_code},
                 :self => %w{service_type_id start_date end_date volunteered paid note} }

  def self.csv_header
    CSV.generate_line(CSV_FIELDS[:person] + CSV_FIELDS[:self])
  end
  
  def to_csv
    values = person.attributes.values_at(*CSV_FIELDS[:person])
    values << service_type_id
    values << start_date ? nil : start_date.to_s(:db)
    values << end_date ? nil : end_date.to_s(:db)
    values << volunteered
    values << paid
    values << note.nil? ? nil : note.text
    CSV.generate_line values
  end
end
