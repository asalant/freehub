class Organization < ActiveRecord::Base
  validates_presence_of :name, :timezone

  def initialize(attributes=nil)
    super(attributes)
    self[:timezone] ||= 'Pacific'
  end
end
