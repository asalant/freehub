class AddOrganizationLocation < ActiveRecord::Migration
  def self.up
    add_column :organizations, :location, :string
  end

  def self.down
    remove_column :organizations, :location
  end
end
