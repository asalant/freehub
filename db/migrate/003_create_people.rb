class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :email
      t.string :phone
      t.boolean :staff
      t.integer :shop_id

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
