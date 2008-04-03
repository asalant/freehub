class Visit < ActiveRecord::Base
  tz_time_attributes :datetime, :created_at, :updated_at
  
  belongs_to :person
  has_one :note, :as => :notable, :dependent => :destroy
  has_userstamps

  validates_presence_of :person_id, :datetime

  acts_as_paginated
  chains_finders

  before_validation :remove_empty_note

  has_finder :for_organization, lambda { |organization| {
      :conditions => [ "people.organization_id = ?", organization ],
      :include => [ :person, :note ],
      :order => 'datetime DESC'
  } }

  has_finder :after, lambda { |date| {
      :conditions => [ "visits.datetime >= ?", TzTime.at(date) ]
  } }

  has_finder :before, lambda { |date| {
      :conditions => [ "visits.datetime < ?", TzTime.at(date) ]
  } }

  def after_initialize
    self.datetime ||= TzTime.now
    self.volunteer ||= false
    self.note ||= Note.new
  end

  def datetime=(value)
    if value.kind_of? String
      write_attribute(:datetime, Time.parse(value))
    else
      write_attribute(:datetime, value)
    end
  end

  def datetime
    read_attribute(:datetime)
  end

  CSV_FIELDS = { :person => %w{first_name last_name staff email email_opt_out phone postal_code},
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

  private

  def remove_empty_note
    self.note = nil if self.note && self.note.empty?
  end

end
