class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string   :login, :nil => false
      t.string   :email, :nil => false
      t.string   :name
      t.string   :crypted_password,          :limit => 40
      t.string   :salt,                      :limit => 40
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.string   :activation_code,           :limit => 40
      t.datetime :activated_at
      t.string   :reset_code,                :limit => 40

      t.timestamps
    end
  end

  def self.down
    drop_table "users"
  end
end
