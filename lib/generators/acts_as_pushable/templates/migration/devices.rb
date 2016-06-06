class Devices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :token
      t.integer :parent_id
      t.string :parent_type
      t.string :platform
      t.boolean :active, default: true
      t.datetime :valid_at
      t.datetime :invalidated_at
      t.datetime :deleted_at
      t.string :platform_version
      t.string :platform_type
      t.string :push_environment
      t.datetime :deactivated_at
      t.timestamps
    end

    add_index :devices, :token, unique: true
  end
end
