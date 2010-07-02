class VisitsArrivedAt < ActiveRecord::Migration
  def self.up
    rename_column :visits, :datetime, :arrived_at
  end

  def self.down
    rename_column :visits, :arrived_at, :datetime
  end
end

