class VisitsArrivedStartEnd < ActiveRecord::Migration
  def self.up
    rename_column :visits, :datetime, :arrived_at
    add_column :visits, :start_at, :datetime
    add_column :visits, :end_at, :datetime
  end

  def self.down
    remove_column :visits, :start_at
    remove_column :visits, :end_at
    rename_column :visits, :arrived_at, :datetime
  end
end
