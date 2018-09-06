# frozen_string_literal: true

class User < ActiveRecord::Base      
  include HasSecureTokens
  include HasFulltextSearch

  has_secure_password
  has_secure_tokens
  rolify      

  validates_uniqueness_of :email,
                          :username  
                          
  # Find a user in the cache with matching 
  # id and token
  def self.find_in_cache(id, token)
    Rails.cache.fetch(["User", id, token], expires_in: 5.minutes) do 
      where('id = ? and tokens like ?', id, "%#{token}%").first 
    end
  end                           
 
end