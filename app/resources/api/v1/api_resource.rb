# frozen_string_literal: true

class Api::V1::ApiResource < JSONAPI::Resource
  
    abstract
  
    filters :id
  
    # Allow a free-text search on resources
    filter :q, apply: ->(records, value, _options) {
      records.search(value[0])
    }
  
    # Allow to filters resources based on a list of ids
    filter :ids, apply: ->(records, value, _options) {
      records.where(records.count > 0 ? "#{records.first.class.table_name}.id IN (?)" : "id IN (?)", value)
    }
  
  
end
  