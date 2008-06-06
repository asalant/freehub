class AddVisitStaffMember < ActiveRecord::Migration
  def self.up
    add_column :visits, :staff, :boolean
    add_column :visits, :member, :boolean
  end

  def self.down
    remove_column :visits, :staff
    remove_column :visits, :member
  end
end
