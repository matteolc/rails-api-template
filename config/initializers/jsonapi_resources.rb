# config/initializers/jsonapi_resources.rb:
JSONAPI.configure do |config|
    # built in paginators are :none, :offset, :paged
    config.default_paginator = :offset
    config.default_page_size = 25
    config.maximum_page_size = 1000
  
    # Do this if you use UUID's instead of Integers for id's
    config.resource_key_type = :uuid
  
    # Metadata
    # Output record count in top level meta for find operation
    config.top_level_meta_include_record_count = true
    config.top_level_meta_record_count_key = :record_count
    config.top_level_meta_include_page_count = false
    config.top_level_meta_page_count_key = :page_count  
    
    config.default_processor_klass = JSONAPI::Authorization::AuthorizingProcessor
    config.exception_class_whitelist = [Pundit::NotAuthorizedError]
    
  end