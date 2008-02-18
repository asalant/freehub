class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name
      t.string :key
      t.string :timezone

      t.timestamps
    end

    add_index(:organizations, [ :key ], :name => 'index_organizations_key', :unique => true)
  end

  def self.down
    drop_table :organizations
  end
end
