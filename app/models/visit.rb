class Visit < ActiveRecord::Base
  belongs_to :person
  has_one :note, :as => :notable, :dependent => :destroy
  has_userstamps

  validates_presence_of :person_id, :datetime

  acts_as_paginated
  chains_finders

  has_finder :for_organization, lambda { |organization| {
      :conditions => [ "people.organization_id = ?", organization ],
      :include => [ :person, :note ],
      :order => 'datetime DESC'
  } }

  has_finder :after, lambda { |date| {
      :conditions => [ "visits.datetime >= ?", date ]
  } }

  has_finder :before, lambda { |date| {
      :conditions => [ "visits.datetime <= ?", date ]
  } }

  def initialize(params={})
    super
    self.datetime ||= Time.now
    self.volunteer ||= false
  end

  CSV_FIELDS = { :person => %w{first_name last_name email phone postal_code},
                 :self => %w{datetime volunteer note} }

  def self.csv_header
    CSV.generate_line(CSV_FIELDS[:person] + CSV_FIELDS[:self])
  end

  def to_csv
    values = person.attributes.values_at(*CSV_FIELDS[:person])
    values << (datetime.nil? ? nil : datetime.to_s(:db))
    values << volunteer
    values << note.nil? ? nil : note.text
    CSV.generate_line values
  end
end
