class Organization < ActiveRecord::Base
  tz_time_attributes :created_at, :updated_at
  
  has_many :people, :dependent => :destroy

  validates_presence_of :name, :key, :timezone
  validates_uniqueness_of :key
  validates_length_of :key, :within => 3..20
  validates_format_of :key, :with => /\A\w+\Z/i
  validate :validate_timezone

  acts_as_authorizable
  
  def initialize(attributes=nil)
    super(attributes)
    self[:timezone] ||= 'Pacific Time (US & Canada)'
  end

  private

  def validate_timezone
    if !errors.on(:timezone)
      errors.add :timezone if !TimeZone[self.timezone]
    end
  end
end
