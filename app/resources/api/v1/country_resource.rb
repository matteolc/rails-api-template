# frozen_string_literal: true

class Api::V1::CountryResource < Api::V1::ApiResource

    caching

    begin
        attributes *Country.attribute_names.map(&:to_sym) -
                    %i[id]                
    rescue
    end                
  
    begin
        filters *Country.attribute_names.map(&:to_sym)
    rescue
    end    
       
end
  