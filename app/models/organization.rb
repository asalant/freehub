# == Schema Information
#
# Table name: organizations
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  key        :string(255)
#  timezone   :string(255)
#  created_at :datetime
#  updated_at :datetime
#  location   :string(255)
#

class Organization < ActiveRecord::Base
  
  has_many :people, :dependent => :destroy

  validates_presence_of :name, :key, :timezone
  validates_length_of :name, :within => 3..40,    :unless => proc { |organization| organization.errors.on :name }
  validates_uniqueness_of :key,                   :unless => proc { |organization| organization.errors.on :key }
  validates_length_of :key, :within => 3..20,     :unless => proc { |organization| organization.errors.on :key }
  validates_format_of :key, :with => /\A\w+\Z/i,  :unless => proc { |organization| organization.errors.on :key }
  validate :validate_timezone

  acts_as_authorizable
  
  def initialize(attributes=nil)
    super(attributes)
    self[:timezone] ||= 'Pacific Time (US & Canada)'
  end

  def member_count
    @member_count ||= Service.for_organization(self).end_after(Date.yesterday).for_service_types(ServiceType[:membership].id).paginate(:size => 0).size
  end

  def visits_count
    @services_count ||= Visit.for_organization(self).count
  end

  def last_visit
    @last_visit ||= Visit.for_organization(self).paginate(:size => 1).to_a.first
  end

  # Active if a visit within last 30 days
  def active?(on = Time.zone.now)
    return false if !self.last_visit

    self.last_visit.arrived_at.to_i > on.ago(30 * 24 * 3600).to_i
  end

  def tag_list
    @tags ||= ActsAsTaggableOn::Tag.find(:all,
               :select => 'tags.id, tags.name',
               :joins => "left join (taggings, people) on (tags.id = taggings.tag_id and taggings.taggable_type = 'Person' and taggings.context = 'tags' and taggings.taggable_id = people.id)",
               :conditions => ["people.organization_id = ?", self]).
            collect(&:name)
  end

  private

  def validate_timezone
    @timezone_names ||= ActiveSupport::TimeZone.us_zones.map { |z| z.name }
    if !errors.on(:timezone)
      errors.add :timezone if !@timezone_names.include?(self.timezone)
    end
  end
end