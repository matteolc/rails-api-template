# frozen_string_literal: true

p 'Generating Countries..'
ISO3166::Country.all.each do |country|
  country = Country.create name: country.name,
                           alpha3: country.alpha3
  p "Created country #{country.name}"
end