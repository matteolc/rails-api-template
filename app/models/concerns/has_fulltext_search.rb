# frozen_string_literal: true

module HasFulltextSearch
    
    extend ActiveSupport::Concern

    class_methods do                    
        def has_fulltext_search(options = {})
        end
    end

    included do
        include PgSearch
        pg_search_scope :search, against: column_names, using: { tsearch: { prefix: true, normalization: 2 } }
    rescue StandardError # we don't have a table yet
    end 
    
end