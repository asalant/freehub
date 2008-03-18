class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.text :text
      t.references :notable, :polymorphic => true

      t.references :created_by, :updated_by
      t.timestamps
    end

    execute "ALTER TABLE notes ADD CONSTRAINT fk_notes_created_by FOREIGN KEY (created_by_id) REFERENCES users(id)"
    execute "ALTER TABLE notes ADD CONSTRAINT fk_notes_updated_by FOREIGN KEY (updated_by_id) REFERENCES users(id)"
  end

  def self.down
    execute "ALTER TABLE notes DROP FOREIGN KEY fk_notes_created_by"
    execute "ALTER TABLE notes DROP FOREIGN KEY fk_notes_updated_by"

    drop_table :notes
  end
end
