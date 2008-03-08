class Visit < ActiveRecord::Base
  belongs_to :person

  validates_presence_of :person_id, :datetime

  acts_as_paginated
  chains_finders

  has_finder :for_organization, lambda { |organization| {
      :conditions => [ "visits.person_id in (select people.id from people where people.organization_id = ?)", organization ],
      :include => [ :person ],
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
  def to_csv
    values = person.attributes.values_at(*CSV_FIELDS[:person])
    values << (datetime.nil? ? nil : datetime.to_s(:db))
    values << volunteer
    values << note
    CSV.generate_line values
  end
end
