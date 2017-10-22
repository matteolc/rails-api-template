class CreateAuthors < ActiveRecord::Migration[5.1]
    def change
      create_table :authors, id: :uuid do |t|
        t.string :nickname
  
        t.timestamps
      end
    end
  end