class Person < ActiveRecord::Base
  belongs_to :organization
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"
  has_many :visits, :dependent => :destroy, :order => "datetime DESC"
  has_many :services, :dependent => :destroy, :include => :service_type,  :order => "start_date DESC"
  
  validates_presence_of :first_name, :organization_id
  #todo: should we check for duplicates by validating unique shop_id, first name, last name, email?

  before_save :update_full_name

  has_finder :for_organization, lambda { |organization| {
      :conditions => { :organization_id => organization },
      :order => 'last_name ASC'
  } }

  has_finder :for_organization_matching_name, lambda { |organization, name| {
      :conditions => [ "LOWER(full_name) LIKE :name AND organization_id = :organization",
              { :name => "%#{name.downcase}%", :organization => organization } ], 
      :order => "full_name ASC",
      :limit => 15
  } }

  private

  def update_full_name
    self.full_name = [first_name, last_name].reject{|e| e.nil? || e.empty?}.join(' ')
  end
end
