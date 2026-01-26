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

  named_scope :active, lambda { |*args|
    on = args.first || Time.zone.now
    thirty_days_ago = on - 30.days
    yesterday = Date.yesterday
    {
      :select => "organizations.*, " \
                 "COUNT(visits.id) as visits_count, " \
                 "MAX(visits.arrived_at) as last_visited_at, " \
                 "(SELECT COUNT(*) FROM services " \
                   "INNER JOIN people AS members ON members.id = services.person_id " \
                   "WHERE members.organization_id = organizations.id " \
                   "AND services.end_date > '#{yesterday}' " \
                   "AND services.service_type_id = 'MEMBERSHIP') as active_member_count",
      :joins => 'INNER JOIN people ON people.organization_id = organizations.id INNER JOIN visits ON visits.person_id = people.id',
      :group => 'organizations.id',
      :having => ['COUNT(visits.id) >= 10 AND MAX(visits.arrived_at) >= ?', thirty_days_ago],
      :order => 'organizations.name ASC'
    }
  }

  def initialize(attributes=nil)
    super(attributes)
    self[:timezone] ||= 'Pacific Time (US & Canada)'
  end

  def member_count
    if val = read_attribute(:active_member_count)
      val.to_i
    else
      @member_count ||= Service.for_organization(self).end_after(Date.yesterday).for_service_types(ServiceType[:membership].id).paginate(:size => 0).size
    end
  end

  def visits_count
    @services_count ||= Visit.for_organization(self).count
  end

  def last_visit
    @last_visit ||= Visit.for_organization(self).paginate(:size => 1).to_a.first
  end

  def last_visited_at
    if val = read_attribute(:last_visited_at)
      Time.zone.parse("#{val} UTC")
    end
  end

  # Active if a visit within last 30 days
  def active?(on = Time.zone.now)
    return false if !self.last_visit

    self.last_visit.arrived_at.to_i > on.ago(30 * 24 * 3600).to_i
  end

  def tags
    unless @tags
      tags = Set.new ActsAsTaggableOn::Tag.find(:all,
                     :select => 'tags.id, tags.name',
                     :joins => "left join (taggings, people) on (tags.id = taggings.tag_id and taggings.taggable_type = 'Person' and taggings.context = 'tags' and taggings.taggable_id = people.id)",
                     :conditions => ["people.organization_id = ?", self])
      @tags = tags.sort_by {|tag| tag.name.downcase}
    end
    @tags
  end

  def tag_list
    tags.collect(&:name)
  end

  private

  def validate_timezone
    @timezone_names ||= ActiveSupport::TimeZone.all.map { |z| z.name }
    if !errors.on(:timezone)
      errors.add :timezone if !@timezone_names.include?(self.timezone)
    end
  end
end