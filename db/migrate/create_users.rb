class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_digest
      t.text :tokens
      t.timestamps
    end
    add_index :users, :email, :unique => true
    add_index :users, :username, :unique => true
  end
end