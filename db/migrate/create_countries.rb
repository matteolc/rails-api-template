# frozen_string_literal: true

class CreateCountries < ActiveRecord::Migration[5.2]
    def change
      create_table :countries, id: :uuid do |t|
        t.citext :name, null: false
        t.string :alpha2
        t.string :alpha3, null: false
        t.string :region
        t.string :subregion
        t.string :world_region
        t.string :country_code
        t.string :international_prefix
        t.string :currency_code
        t.string :currency_name
        t.string :currency_symbol
        t.string :timezones, array: true
        t.string :timezones_offsets, array: true
        t.timestamps
      end
  
      add_index :countries, :name, unique: true
    end
end
  