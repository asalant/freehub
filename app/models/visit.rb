class Visit < ActiveRecord::Base
  belongs_to :person

  acts_as_paginated
  
  has_finder :for_person, lambda { |person| {
      :conditions => { :person_id => person},
      :order => 'datetime DESC'
  } }

  has_finder :for_organization, lambda { |organization| {
      :conditions => [ "visits.person_id in (select people.id from people where people.organization_id = ?)", organization ],
      :include => [ :person ],
      :order => 'datetime DESC'
  } }

  has_finder :after, lambda { |date| {
      :conditions => [ "visits.datetime >= ?", date ]
  } }

  has_finder :before, lambda { |date| {
      :conditions => [ "visits.datetime <= ?", date ]
  } }

  def self.chain_finders(finders={})
    target = self
    finders.each do |name, args|
      target = target.send name, args
    end
    target
  end

  # todo: http://wiki.rubyonrails.org/rails/pages/HowtoExportDataAsCSV
  def to_csv(options={ :person => { :include => [ :first_name, :last_name, :email, :phone, :postal_code ] },
                       :visit => { :include => [ :datetime, :volunteered ] }})
    CSV.generate_line(person.attributes.values_at(*options[:person][:include].collect { |entry| entry.to_s }) +
                      attributes.values_at(*options[:visit][:include].collect { |entry| entry.to_s }))
  end
end
