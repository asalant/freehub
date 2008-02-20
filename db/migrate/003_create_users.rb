class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string :login
      t.string :email
      t.string :name
      t.string :crypted_password,          :limit => 40
      t.string :salt,                      :limit => 40
      t.string :remember_token
      t.datetime :remember_token_expires_at

      t.timestamps

      t.references :organization      
    end

    execute "ALTER TABLE people ADD CONSTRAINT fk_userts_organization FOREIGN KEY (organization_id) REFERENCES users(id)"
  end

  def self.down
    drop_table "users"
  end
end
