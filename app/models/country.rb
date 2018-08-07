# frozen_string_literal: true
# ## Schema Information
#
# Table name: `countries`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `uuid`             | `not null, primary key`
# **`name`**                  | `citext`           | `not null`
# **`alpha2`**                | `string`           |
# **`alpha3`**                | `string`           | `not null`
# **`region`**                | `string`           |
# **`subregion`**             | `string`           |
# **`world_region`**          | `string`           |
# **`country_code`**          | `string`           |
# **`international_prefix`**  | `string`           |
# **`currency_code`**         | `string`           |
# **`currency_name`**         | `string`           |
# **`currency_symbol`**       | `string`           |
# **`timezones`**             | `string`           | `is an Array`
# **`timezones_offsets`**     | `string`           | `is an Array`
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_countries_on_name` (_unique_):
#     * **`name`**
#

class Country < ApplicationRecord
    include HasFulltextSearch
    include SpreadsheetArchitect

    by_star_field :updated_at
  
    validates_uniqueness_of :name,
                            case_sensitive: false
  
    validates :alpha3,
              inclusion: { in: ISO3166::Country.all.map(&:alpha3) },
              presence: true
    
    def iso3166_country
      ISO3166::Country.find_country_by_alpha3(alpha3)
    end
  
    def tz_info
      TZInfo::Country.get(iso3166_country.alpha2)
    end
  
    before_save :set_or_update_country_info
    def set_or_update_country_info
      self.alpha2 = iso3166_country.alpha2
      self.region = iso3166_country.continent
      self.subregion = iso3166_country.subregion
      self.world_region = iso3166_country.world_region
      self.international_prefix = iso3166_country.international_prefix
      self.country_code = iso3166_country.country_code
    end
  
    before_save :set_or_update_currency_info
    def set_or_update_currency_info
      return if iso3166_country.currency.nil?
      self.currency_code = iso3166_country.currency.iso_code
      self.currency_symbol = iso3166_country.currency.symbol
      self.currency_name = iso3166_country.currency.name
    end
  
    before_save :set_or_update_timezones_info
    def set_or_update_timezones_info
      timezones_offsets = []
      tz_info.zone_identifiers.each do |time_zone|
        timezones_offsets.push(Time.now.in_time_zone(time_zone).formatted_offset)
      end
      self.timezones = tz_info.zone_identifiers
      self.timezones_offsets = timezones_offsets
    rescue StandardError # TZInfo::InvalidCountryCode: Invalid country code
    end
  
    after_commit :flush_cache, on: [:update, :destroy]
  
    def flush_cache
      Rails.cache.delete(["Country", self.id])
    end
  
    def self.find_in_cache(id)
      Rails.cache.fetch(["Country", id], expires_in: 1.day) do find(id) end
    end

    def to_pdf
      pdf = WickedPdf.new.pdf_from_string(
        ActionController::Base.new.render_to_string('pdf/country.html', layout: 'layouts/pdf.html', locals: { country: self }),
        margin: { 
          top: 10,
          bottom: 10,
          left: 10,
          right: 10 
        },
        footer: { center: '[page] of [topage]' })
      save_path = Rails.root.join('tmp', "#{name}.pdf")
      File.open(save_path, 'wb') do |file| file << pdf end
      save_path
    end    
  
  end
  