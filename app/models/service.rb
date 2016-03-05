# == Schema Information
#
# Table name: services
#
#  id              :integer(4)      not null, primary key
#  start_date      :date
#  end_date        :date
#  paid            :boolean(1)      default(FALSE)
#  volunteered     :boolean(1)      default(FALSE)
#  service_type_id :string(255)
#  person_id       :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  created_by_id   :integer(4)
#  updated_by_id   :integer(4)
#

class Service < ActiveRecord::Base
  
  belongs_to :person
  has_one :note, :as => :notable, :dependent => :destroy
  has_userstamps

  validates_presence_of :person_id, :service_type_id
  
  acts_as_paginated
  chains_finders

  before_validation :remove_empty_note

  named_scope :for_organization, lambda { |organization| {
      :conditions => [ "people.organization_id = ?", organization ],
      :include => [ :person, :note ]
  } }

  named_scope :end_after, lambda { |date| {
      :conditions => [ "services.end_date > ?", date ]
  } }

  named_scope :end_before, lambda { |date| {
      :conditions => [ "services.end_date < ?", date ]
  } }

  named_scope :for_service_types, lambda { |service_types| {
      :conditions => [ "services.service_type_id IN (?)", service_types ]
  } }

  def initialize(params={})
    super
    self.start_date ||= Date.today
    self.end_date ||= Date.today.next_year
    self.note ||= Note.new
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
    if note.nil?
      values << nil
    else
      values << note.text
    end
    CSV.generate_line values
  end

  private

  def remove_empty_note
    self.note = nil if self.note && self.note.empty?
  end
end
