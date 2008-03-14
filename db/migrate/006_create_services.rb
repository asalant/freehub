class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.date :start_date
      t.date :end_date
      t.boolean :paid, :default => false
      t.boolean :volunteered, :default => false
      t.text :note
      t.string :service_type_id, :nil => false
      t.references :person, :nil => false

      t.timestamps
      t.references :created_by, :updated_by
    end

    execute "ALTER TABLE services ADD CONSTRAINT fk_services_created_by FOREIGN KEY (created_by_id) REFERENCES users(id)"
    execute "ALTER TABLE services ADD CONSTRAINT fk_services_updated_by FOREIGN KEY (updated_by_id) REFERENCES users(id)"
    execute "ALTER TABLE services ADD CONSTRAINT fk_services_person FOREIGN KEY (person_id) REFERENCES people(id)"
  end

  def self.down
    execute "ALTER TABLE services DROP FOREIGN KEY fk_services_created_by"
    execute "ALTER TABLE services DROP FOREIGN KEY fk_services_updated_by"
    execute "ALTER TABLE services DROP FOREIGN KEY fk_services_person"

    drop_table :services
  end
end
