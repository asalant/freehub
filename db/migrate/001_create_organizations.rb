class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name, :nil => false
      t.string :key, :nil => false
      t.string :timezone

      t.timestamps
    end

    add_index :organizations, :key , :unique => true
  end

  def self.down
    drop_table :organizations
  end
end
