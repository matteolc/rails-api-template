class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, id: :uuid  do |t|
      ## Required
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""
      t.string :username, :null => false

      ## Database authenticatable
      t.string :encrypted_password, :null => false, :default => ""     

      ## Trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## User Info
      t.string :name
      t.string :nickname
      t.string :image
      t.string :email

      ## Tokens
      t.json :tokens

      t.timestamps
    end

    add_index :users, :email
    add_index :users, [:uid, :provider],     :unique => true
    add_index :users, [:username, :provider],:unique => true
  end
end
