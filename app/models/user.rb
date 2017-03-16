class User < ApplicationRecord
	
  devise :database_authenticatable, :authentication_keys => [:username]
  devise :trackable
         
  include DeviseTokenAuth::Concerns::User
  
  include PgSearch      
  pg_search_scope :search, against: column_names, using: { tsearch: { prefix: true, normalization: 2 } }
    
  rolify                     
  has_many :roles, through: :users_roles

  def token_validation_response
  	{ id: id, username: username, roles: roles.map(&:name) }.as_json  	
  end 
  
end