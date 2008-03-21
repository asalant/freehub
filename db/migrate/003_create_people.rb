class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :full_name
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :email
      t.boolean :email_opt_out, :nil => false, :default => false
      t.string :phone
      t.boolean :staff, :nil => false, :default => false

      t.timestamps
      t.references :created_by, :updated_by
      t.references :organization, :nil => false
    end

    execute "ALTER TABLE people ADD CONSTRAINT fk_people_created_by FOREIGN KEY (created_by_id) REFERENCES users(id)"
    execute "ALTER TABLE people ADD CONSTRAINT fk_people_updated_by FOREIGN KEY (updated_by_id) REFERENCES users(id)"
    execute "ALTER TABLE people ADD CONSTRAINT fk_people_organization FOREIGN KEY (organization_id) REFERENCES organizations(id)"
  end

  def self.down
    execute "ALTER TABLE people DROP FOREIGN KEY fk_people_created_by"
    execute "ALTER TABLE people DROP FOREIGN KEY fk_people_updated_by"
    execute "ALTER TABLE people DROP FOREIGN KEY fk_people_organization"

    drop_table :people
  end
end
