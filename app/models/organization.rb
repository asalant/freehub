class Organization < ActiveRecord::Base
  has_many :people, :dependent => :destroy

  validates_presence_of :name, :key, :timezone
  validates_uniqueness_of :key
  validates_length_of :key, :within => 3..20
  validates_format_of :key, :with => /\A\w+\Z/i

  acts_as_authorizable
  
  def initialize(attributes=nil)
    super(attributes)
    self[:timezone] ||= 'Pacific'
  end
end
