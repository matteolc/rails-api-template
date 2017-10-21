class User < ActiveRecord::Base
  has_secure_password    
  include HasSecureTokens
  has_secure_tokens
  rolify    

  validates_uniqueness_of :email,
                          :username    
 
end