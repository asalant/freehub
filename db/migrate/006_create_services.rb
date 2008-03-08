class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :service_types do |t|
      t.string :name, :nil => false
      t.string :description

      t.timestamps
    end

    create_table :services do |t|
      t.date :start_date
      t.date :end_date
      t.boolean :paid, :default => false
      t.boolean :volunteered, :default => false
      t.text :note
      t.references :service_type, :nil => false
      t.references :person, :nil => false

      t.timestamps
      t.references :created_by, :updated_by
    end

    execute "ALTER TABLE services ADD CONSTRAINT fk_services_created_by FOREIGN KEY (created_by_id) REFERENCES users(id)"
    execute "ALTER TABLE services ADD CONSTRAINT fk_services_updated_by FOREIGN KEY (updated_by_id) REFERENCES users(id)"
    execute "ALTER TABLE services ADD CONSTRAINT fk_services_service_type FOREIGN KEY (service_type_id) REFERENCES service_types(id)"
    execute "ALTER TABLE services ADD CONSTRAINT fk_services_person FOREIGN KEY (person_id) REFERENCES people(id)"

    ServiceType.create!(:name => 'Membership', :description => 'Membership for this shop.')
    ServiceType.create!(:name => 'Class', :description => 'A class run by this shop.')
    ServiceType.create!(:name => 'Digging Rights', :description => 'One of everything you can find in the shop to build or fix one bike.')
  end

  def self.down
    execute "ALTER TABLE services DROP FOREIGN KEY fk_services_created_by"
    execute "ALTER TABLE services DROP FOREIGN KEY fk_services_updated_by"
    execute "ALTER TABLE services DROP FOREIGN KEY fk_services_service_type"
    execute "ALTER TABLE services DROP FOREIGN KEY fk_services_person"

    drop_table :services
    drop_table :service_types
  end
end

class ServiceType < ActiveRecord::Base
  
end
