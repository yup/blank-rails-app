class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :password_hash, :password_salt, :full_name, :email
      t.timestamps
    end
    
    add_index(:users, :username)
  end

  def self.down
    drop_table :users
  end
end
