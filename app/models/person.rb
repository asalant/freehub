class Person < ActiveRecord::Base
  tz_time_attributes :created_at, :updated_at
  
  belongs_to :organization
  has_many :visits, :include => :note, :dependent => :destroy, :order => "datetime DESC"
  has_many :services, :include => :note, :dependent => :destroy,  :order => "end_date DESC" do
    def last(service_type)
      for_service_types(ServiceType[service_type].id).first
    end
  end
  has_many :notes, :as => :notable, :dependent => :destroy

  has_userstamps
  
  validates_presence_of :first_name, :organization_id
  validates_uniqueness_of :email, :scope => :organization_id, :case_sensitive => false, :allow_nil => true, :allow_blank => true
  validates_length_of :first_name, :last_name, :street1, :street2, :city, :state, :postal_code, :country, :within => 1..40, :allow_blank => true
  validates_email_veracity_of :email, :domain_check => false

  before_save :titleize_name, :update_full_name, :titleize_address, :downcase_email
  
  acts_as_paginated
  chains_finders

  has_finder :for_organization, lambda { |organization| {
      :conditions => { :organization_id => organization },
  } }

  has_finder :after, lambda { |date| {
      :conditions => [ "people.created_at >= ?", TzTime.at(date) ]
  } }

  has_finder :before, lambda { |date| {
      :conditions => [ "people.created_at < ?", TzTime.at(date) ]
  } }

  has_finder :matching_name, lambda { |name| {
      :conditions => [ "LOWER(full_name) LIKE :name", { :name => "%#{name.downcase}%"} ], 
      :order => "full_name ASC"
  } }

  CSV_FIELDS = { :self => %w{first_name last_name staff email email_opt_out phone postal_code street1 street2 city state postal_code country created_at membership_expires_on} }

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
