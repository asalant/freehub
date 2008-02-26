class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.string :target
      t.date :date_from
      t.date :date_to

      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
