# == Schema Information
#
# Table name: people
#
#  id              :integer(4)      not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  full_name       :string(255)
#  street1         :string(255)
#  street2         :string(255)
#  city            :string(255)
#  state           :string(255)
#  postal_code     :string(255)
#  country         :string(255)
#  email           :string(255)
#  email_opt_out   :boolean(1)      default(FALSE)
#  phone           :string(255)
#  staff           :boolean(1)      default(FALSE)
#  created_at      :datetime
#  updated_at      :datetime
#  created_by_id   :integer(4)
#  updated_by_id   :integer(4)
#  organization_id :integer(4)
#  yob             :integer(4)
#

class Person < ActiveRecord::Base

  belongs_to :organization
  has_many :visits, :include => :note, :dependent => :destroy, :order => "arrived_at DESC"
  has_many :services, :include => :note, :dependent => :destroy,  :order => "end_date DESC" do
    def last(service_type)
      self.detect { |service| service.service_type_id == ServiceType[service_type].id }
    end

    def on(service_type, time)
      self.detect { |service|
        service.service_type_id == ServiceType[service_type].id &&
            (service.start_date.nil? || service.start_date <= time.to_date) &&
            (service.end_date.nil? || service.end_date > time.to_date)
      }
    end
  end
  has_many :notes, :as => :notable, :dependent => :destroy

  has_userstamps

  validates_presence_of :first_name, :organization_id
  validates_uniqueness_of :email, :scope => :organization_id, :case_sensitive => false, :allow_nil => true, :allow_blank => true
  validates_length_of :first_name, :last_name, :street1, :street2, :city, :state, :postal_code, :country, :within => 1..40, :allow_blank => true
  validates_email_format_of :email, :check_mx => true
  # Note that Date.today gets evaluates at class load time, not evaluation time, but we can live with that fudge
  validates_numericality_of :yob, :allow_nil => true, :only_integer => true, :greater_than => Date.today.year - 100, :less_than => Date.today.year + 1

  before_validation :trim_attributes
  before_save :titleize_name, :update_full_name, :titleize_address, :downcase_email

  acts_as_taggable
  acts_as_paginated
  chains_finders

  named_scope :for_organization, lambda { |organization| {
      :conditions => { :organization_id => organization },
      :order => "full_name ASC"
  } }

  named_scope :after, lambda { |date| {
      :conditions => [ "people.created_at >= ?", date.to_date.to_time.utc ]
  } }

  named_scope :before, lambda { |date| {
      :conditions => [ "people.created_at < ?", date.to_date.to_time.utc ]
  } }

  named_scope :matching_name, lambda { |name| {
      :conditions => [ "LOWER(full_name) LIKE :name", { :name => "%#{name.downcase}%"} ]
  } }

  def initialize(params={})
    super
    self.country ||= 'US'
  end

  def membership
    @membership ||= services.last(:membership)
  end

  def member?
    !membership.nil? && membership.current?
  end

  def membership_on(time)
    services.on(:membership, time)
  end

  def member_on?(time)
    !services.on(:membership, time).nil?
  end

  def person_type
    if staff?
      'Staff'
    elsif member?
      'Member'
    else
      'Patron'
    end
  end

  def tag_list_with_sorting
    tag_list_without_sorting.sort!
  end
  alias_method_chain :tag_list, :sorting

  CSV_FIELDS = { :self => %w{id first_name last_name staff email email_opt_out phone postal_code street1 street2 city state postal_code country yob created_at membership_expires_on} }

  def self.csv_header
    CSV.generate_line(CSV_FIELDS[:self])
  end

  def to_csv
    values = self.attributes.values_at(*CSV_FIELDS[:self])
    values[values.size - 2] = created_at.nil? ? nil : created_at.to_s(:db)
    values[values.size - 1] = self.services.last(:membership).nil? ? nil : self.services.last(:membership).end_date.to_s(:db)
    CSV.generate_line values
  end

  private

  def trim_attributes
    self.first_name.strip! if !self.first_name.blank?
    self.last_name.strip! if !self.last_name.blank?
    self.email.strip! if !self.email.blank?
  end

  def titleize_name
    self.first_name = self.first_name.titleize if !self.first_name.blank?
    if !self.last_name.blank?
      parts = self.last_name.split " "
      parts << parts.pop.titleize
      self.last_name = parts.join " "
    end
  end

  def titleize_address
    self.street1 = self.street1.titleize if !self.street1.blank?
    self.street2 = self.street2.titleize if !self.street2.blank?
    self.city = self.city.titleize if !self.city.blank?
    self.state = self.state.upcase if !self.state.blank? && self.state != self.state.titleize
  end

  def downcase_email
    self.email = self.email.downcase if !self.email.blank?
  end

  def update_full_name
    self.full_name = [first_name, last_name].reject{|e| e.nil? || e.empty?}.join(' ')
  end
end
