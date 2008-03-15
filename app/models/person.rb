class Person < ActiveRecord::Base
  belongs_to :organization
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"
  has_many :visits, :dependent => :destroy, :order => "datetime DESC"
  has_many :services, :dependent => :destroy,  :order => "start_date DESC"
  
  validates_presence_of :first_name, :organization_id
  validates_uniqueness_of :email, :scope => :organization_id, :case_sensitive => false, :allow_nil => true, :allow_blank => true
  validates_email_veracity_of :email

  before_save :update_full_name
  
  acts_as_paginated

  has_finder :for_organization, lambda { |organization| {
      :conditions => { :organization_id => organization }
  } }

  has_finder :matching_name, lambda { |name| {
      :conditions => [ "LOWER(full_name) LIKE :name", { :name => "%#{name.downcase}%"} ], 
      :order => "full_name ASC"
  } }

  private

  def update_full_name
    self.full_name = [first_name, last_name].reject{|e| e.nil? || e.empty?}.join(' ')
  end
end
