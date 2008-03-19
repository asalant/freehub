class Note < ActiveRecord::Base
  belongs_to :notable, :polymorphic => true
  has_userstamps

  validates_presence_of :notable_type, :notable_id, :text

  def self.for_person(person, options={})
    options[:order] ||= 'notes.created_at DESC'
    find_by_sql for_person_sql(person, options)
  end

  def self.count_for_person(person, options={})
    count_by_sql for_person_sql(person, options.merge(:select => 'COUNT(*)'))
  end

  private

  def self.for_person_sql(person, options={})
    options[:select] ||= '*'
    options[:offset] ||= 0
    sql = "SELECT #{options[:select]} FROM notes
            WHERE (notes.notable_type = 'Person' AND notes.notable_id = #{person.id})
            OR  (notes.notable_type = 'Service' AND notes.notable_id IN (SELECT services.id FROM services WHERE services.person_id = #{person.id}))
            OR  (notes.notable_type = 'Visit' AND notes.notable_id IN (SELECT visits.id FROM visits WHERE visits.person_id = #{person.id}))"

    sql += " ORDER BY #{options[:order]}" if options[:order]
    sql += " LIMIT #{options[:offset]},#{options[:limit]}" if options[:limit]
    sql
  end
  
end
