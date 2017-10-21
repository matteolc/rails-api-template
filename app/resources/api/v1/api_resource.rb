class Api::V1::ApiResource < JSONAPI::Resource
    
    include JSONAPI::Authorization::PunditScopedResource

    abstract

    attributes :created_at,
               :updated_at  
                
    filters :id

    # Allow a free-text search on resources
    filter :q, apply: ->(records, value, _options) {
        records.search(value[0])
    }  
    
    # Allow to filters resources based on a list of ids
    filter :ids, apply: ->(records, value, _options) {
        records.where('id IN (?)', value[0])
    }     

end
    