class User < ApplicationRecord
	
  devise :database_authenticatable, :authentication_keys => [:username]
  devise :trackable
         
  include DeviseTokenAuth::Concerns::User
      
  rolify                     

  def token_validation_response
  	{ id: id, username: username, roles: roles.map(&:name) }.as_json  	
  end 
  
end