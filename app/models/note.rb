# == Schema Information
#
# Table name: notes
#
#  id            :integer(4)      not null, primary key
#  text          :text
#  notable_id    :integer(4)
#  notable_type  :string(255)
#  created_by_id :integer(4)
#  updated_by_id :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#

class Note < ActiveRecord::Base

  belongs_to :notable, :polymorphic => true
  has_userstamps

  validates_presence_of :notable_type, :notable_id

  def self.for_person(person, options={})
    options[:order] ||= 'notes.created_at DESC'
    find_by_sql for_person_sql(person, options)
  end

  def self.count_for_person(person, options={})
    count_by_sql for_person_sql(person, options.merge(:select => 'COUNT(*)'))
  end

  def empty?
    self.text.nil? || self.text.empty?
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
    sql += " LIMIT #{options[:limit]}" if options[:limit]
    sql += " OFFSET #{options[:offset]} "
    sql
  end
  
end
