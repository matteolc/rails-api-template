# frozen_string_literal: true

class Api::V1::CountryResource < Api::V1::ApiResource

    caching
  
    attributes *Country.attribute_names.map(&:to_sym) -
                %i[id]                
  
    filters *Country.attribute_names.map(&:to_sym)
       
end
  