class Visit < ActiveRecord::Base
  belongs_to :person

  acts_as_paginated :size => 20
  
  has_finder :for_person, lambda { |person| {
      :conditions => { :person_id => person},
      :order => 'datetime DESC'
  } }

  has_finder :for_organization, lambda { |organization| {
      :conditions => [ "visits.person_id in (select people.id from people where people.organization_id = ?)", organization ],
      :include => [ :person ],
      :order => 'datetime DESC'
  } }

  has_finder :in_date_range, lambda { |from,to| {
      :conditions => [ "visits.datetime >= ? and visits.datetime <= ?", from, to ]
  } }
  
end
