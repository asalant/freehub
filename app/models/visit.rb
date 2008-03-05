class Visit < ActiveRecord::Base
  belongs_to :person

  validates_presence_of :person, :datetime

  acts_as_paginated
  
  has_finder :for_person, lambda { |person| {
      :conditions => { :person_id => person},
      :order => 'datetime DESC'
  } }

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

  def self.chain_finders(finders={})
    target = self
    finders.each do |name, args|
      target = target.send name, args
    end
    target
  end

  def initialize(params={})
    super
    self.datetime ||= Time.now
    self.volunteer ||= false
  end

  def datetime_db
    datetime.strftime("%Y-%m-%d %H:%M")
  end

  CSV_FIELDS = { :person => %w{first_name last_name email phone postal_code},
                 :self => %w{datetime volunteered} }
  def to_csv
    values = person.attributes.values_at(*CSV_FIELDS[:person]) + attributes.values_at(*CSV_FIELDS[:self])
    datetime_index = CSV_FIELDS[:person].size # todo: could be more elegant
    values[datetime_index] = values[datetime_index].to_s(:db) if values[datetime_index]
    CSV.generate_line values
  end
end
