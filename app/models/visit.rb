class Visit < ActiveRecord::Base
  belongs_to :person

  def self.find_by_person(person, paging_params = {})
    find(:all, :conditions => { :person_id => person }, :order => 'datetime DESC',
               :page => paging_params)
  end

  def self.find_by_organization(organization, paging_params = {})
    find(:all, :conditions => [ "visits.person_id in (select people.id from people where people.organization_id = ?)", organization.id ],
               :order => 'datetime DESC',
               :page => paging_params)
  end
end
