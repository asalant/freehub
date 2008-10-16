class AddPersonYearOfBirth < ActiveRecord::Migration
  def self.up
    add_column :people, :yob, :integer
  end

  def self.down
    remove_column :people, :yob
  end
end
