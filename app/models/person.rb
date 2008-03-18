class Person < ActiveRecord::Base
  belongs_to :organization
  has_many :visits, :include => :note, :dependent => :destroy, :order => "datetime DESC"
  has_many :services, :include => :note, :dependent => :destroy,  :order => "end_date DESC" do
    def last(service_type)
      for_service_types(ServiceType[service_type].id).first
    end
  end
  has_many :notes, :as => :notable, :dependent => :destroy,
          :finder_sql => 'SELECT * FROM notes
            WHERE (notes.notable_type = \'Person\' AND notes.notable_id = #{id})
            OR  (notes.notable_type = \'Service\' AND notes.notable_id IN (SELECT services.id FROM services WHERE services.person_id = #{id}))
            OR  (notes.notable_type = \'Visit\' AND notes.notable_id IN (SELECT visits.id FROM visits WHERE visits.person_id = #{id}))
            ORDER BY notes.created_at DESC',
          :counter_sql => 'SELECT COUNT(*) FROM notes
            WHERE (notes.notable_type = \'Person\' AND notes.notable_id = #{id})
            OR  (notes.notable_type = \'Service\' AND notes.notable_id IN (SELECT services.id FROM services WHERE services.person_id = #{id}))
            OR  (notes.notable_type = \'Visit\' AND notes.notable_id IN (SELECT visits.id FROM visits WHERE visits.person_id = #{id}))'

=begin
TODO: optimize the above
          :finder_sql => 'SELECT * FROM notes
                         LEFT OUTER JOIN services ON services.person_id = #{id}
                         LEFT OUTER JOIN visits ON visits.person_id = #{id}
                         WHERE ((notes.notable_type = \'Person\' and notes.notable_id = #{id})
                         OR  (notes.notable_type = \'Service\' and notes.notable_id = services.id)
                         OR  (notes.notable_type = \'Visit\' and notes.notable_id = visits.id))'
=end

  has_userstamps
  
  validates_presence_of :first_name, :organization_id
  validates_uniqueness_of :email, :scope => :organization_id, :case_sensitive => false, :allow_nil => true, :allow_blank => true
  validates_email_veracity_of :email

  before_save :update_full_name
  
  acts_as_paginated
  chains_finders

  has_finder :for_organization, lambda { |organization| {
      :conditions => { :organization_id => organization },
  } }

  has_finder :after, lambda { |date| {
      :conditions => [ "people.created_at >= ?", date ]
  } }

  has_finder :before, lambda { |date| {
      :conditions => [ "people.created_at <= ?", date ]
  } }

  has_finder :matching_name, lambda { |name| {
      :conditions => [ "LOWER(full_name) LIKE :name", { :name => "%#{name.downcase}%"} ], 
      :order => "full_name ASC"
  } }

  CSV_FIELDS = { :self => %w{first_name last_name staff email phone postal_code street1 street2 city state postal_code country created_at} }

  def self.csv_header
    CSV.generate_line(CSV_FIELDS[:self])
  end

  def to_csv
    values = self.attributes.values_at(*CSV_FIELDS[:self])
    values[values.size - 1] = created_at.nil? ? nil : created_at.to_s(:db)
    CSV.generate_line values
  end

  private

  def update_full_name
    self.full_name = [first_name, last_name].reject{|e| e.nil? || e.empty?}.join(' ')
  end
end
