# frozen_string_literal: true

class Api::V1::CountryResource < Api::V1::ApiResource

    caching

    begin
        attributes *Country.attribute_names.map(&:to_sym) -
                    %i[id] +
                    %i[effective_exchange_rate]                 
    rescue
    end                
  
    begin
        filters *Country.attribute_names.map(&:to_sym)
    rescue
    end   
    
    filter :updated_at_geq, apply: ->(records, value, _options) {
        records.after(value)
    }
      
    filter :updated_at_leq, apply: ->(records, value, _options) {
        records.before(value)
    }  

    # no-op on virtual attributes
    def effective_exchange_rate=(_)
    end    
       
end
  