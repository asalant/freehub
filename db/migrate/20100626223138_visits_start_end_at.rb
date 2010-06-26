class VisitsStartEndAt < ActiveRecord::Migration
  def self.up
    add_column :visits, :start_at, :datetime
    add_column :visits, :end_at, :datetime
  end

  def self.down
    remove_column :visits, :start_at
    remove_column :visits, :end_at    
  end
end
