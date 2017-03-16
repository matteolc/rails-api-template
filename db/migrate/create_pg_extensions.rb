class CreatePgExtensions < ActiveRecord::Migration[5.0]
  def change
  	unless extension_enabled?('uuid-ossp')
      execute 'create extension "uuid-ossp"'
      enable_extension 'uuid-ossp'
    end
  	unless extension_enabled?('citext')
      execute 'create extension "citext"'
      enable_extension 'citext'
    end
  	unless extension_enabled?('hstore')
      execute 'create extension "hstore"'
      enable_extension 'hstore'
    end      
  end
end