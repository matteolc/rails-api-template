class CreatePosts < ActiveRecord::Migration[5.1]
    def change
      create_table :posts, id: :uuid do |t|
        t.string :title, null: false
        t.text :body, null: false
        t.references :author, foreign_key: true, type: :uuid
        t.datetime :published_at, default: Time.now
        t.integer :likes, default: 0
        t.boolean :published, default: false
        t.string :category, null: false
  
        t.timestamps
      end
    end
  end