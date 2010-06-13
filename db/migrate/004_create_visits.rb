class CreateVisits < ActiveRecord::Migration
  def self.up
    create_table :visits do |t|
      t.datetime :arrived_at, :nil => false
      t.boolean :volunteer, :nil => false, :default => false

      t.timestamps
      t.references :created_by, :updated_by
      t.references :person, :nil => false
    end

    execute "ALTER TABLE visits ADD CONSTRAINT fk_visits_created_by FOREIGN KEY (created_by_id) REFERENCES users(id)"
    execute "ALTER TABLE visits ADD CONSTRAINT fk_visits_updated_by FOREIGN KEY (updated_by_id) REFERENCES users(id)"
    execute "ALTER TABLE visits ADD CONSTRAINT fk_visits_person FOREIGN KEY (person_id) REFERENCES people(id)"
  end

  def self.down
    execute "ALTER TABLE visits DROP FOREIGN KEY fk_visits_created_by"
    execute "ALTER TABLE visits DROP FOREIGN KEY fk_visits_updated_by"
    execute "ALTER TABLE visits DROP FOREIGN KEY fk_visits_person"

    drop_table :visits
  end
end
