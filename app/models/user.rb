# frozen_string_literal: true

class User < ActiveRecord::Base
  has_secure_password    
  include HasSecureTokens
  has_secure_tokens
  rolify    

  validates_uniqueness_of :email,
                          :username  
                          
  def self.find_in_cache(username, token)
    Rails.cache.fetch(["User", username, token], expires_in: 1.day) do 
      where('username = ? and tokens like ?', username, "%#{token}%").first 
    end
  end                           
 
end