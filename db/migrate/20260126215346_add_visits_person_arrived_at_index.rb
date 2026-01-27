class AddVisitsPersonArrivedAtIndex < ActiveRecord::Migration
  def self.up
    add_index :visits, [:person_id, :arrived_at], :name => 'index_visits_on_person_id_and_arrived_at'
  end

  def self.down
    remove_index :visits, :name => 'index_visits_on_person_id_and_arrived_at'
  end
end
