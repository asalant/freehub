class Visit < ActiveRecord::Base
  belongs_to :person

  has_finder :for_person, lambda { |person| { :conditions => { :person_id => person}, :order => 'datetime DESC' } }

  has_finder :for_organization, lambda { |organization| {
      :conditions => [ "visits.person_id in (select people.id from people where people.organization_id = ?)", organization ],
      :order => 'datetime DESC'
  } }

  has_finder :in_date_range, lambda { |from,to| { :conditions => [ "visits.datetime >= ? and visits.datetime <= ?", from, to ] } }
  
  def self.paginated(args={})
    options = { :page => 1, :size => 10 }.merge(args)
    find  :all, :page => {
            :size     => options[:size],
            :current  => options[:page],
            :first    => 1 }
  end
end
