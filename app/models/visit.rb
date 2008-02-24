class Visit < ActiveRecord::Base
  belongs_to :person

  def self.find_by_person(person, paging_params = {})
    find(:all, :conditions => { :person_id => person }, :order => 'datetime DESC',
               :page => paging_params)
  end
end
