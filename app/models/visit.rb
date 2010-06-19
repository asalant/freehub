# == Schema Information
#
# Table name: visits
#
#  id            :integer(4)      not null, primary key
#  datetime      :datetime
#  volunteer     :boolean(1)      default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#  created_by_id :integer(4)
#  updated_by_id :integer(4)
#  person_id     :integer(4)
#  staff         :boolean(1)
#  member        :boolean(1)
#

class Visit < ActiveRecord::Base
  
  belongs_to :person
  has_one :note, :as => :notable, :dependent => :destroy
  has_userstamps

  validates_presence_of :person_id, :datetime

  acts_as_paginated
  chains_finders

  before_save :remove_empty_note, :record_staff_status, :record_member_status

  named_scope :for_organization, lambda { |organization| {
      :conditions => [ "people.organization_id = ?", organization ],
      :include => [ :person, :note ],
      :order => 'datetime DESC'
  } }

  named_scope :after, lambda { |date| {
      :conditions => [ "convert_tz(visits.datetime,'+00:00','#{Time.zone.formatted_offset}') >= ?", date.to_date.to_time.utc ]
  } }

  named_scope :before, lambda { |date| {
      :conditions => [ "convert_tz(visits.datetime,'+00:00','#{Time.zone.formatted_offset}') < ?", date.to_date.to_time.utc ]
  } }

  def initialize(params={})
    super
    self.datetime ||= Time.now
    self.volunteer ||= false
    self.note ||= Note.new
  end

  CSV_FIELDS = { :person => %w{first_name last_name email email_opt_out phone postal_code},
                 :self => %w{datetime staff member volunteer note} }

  def self.csv_header
    CSV.generate_line(CSV_FIELDS[:person] + CSV_FIELDS[:self])
  end

  def to_csv
    values = person.attributes.values_at(*CSV_FIELDS[:person])
    values << (datetime.nil? ? nil : datetime.strftime("%Y-%m-%d %H:%M"))
    values << staff?
    values << member?
    values << volunteer?
    values << (note.nil? ? nil : note.text)
    CSV.generate_line values
  end

  private

  def remove_empty_note
    self.note = nil if self.note && self.note.empty?
  end

  def record_staff_status
    self.staff = person.staff?
    true
  end

  def record_member_status
    self.member = person.member_on?(datetime)
    true
  end

end
