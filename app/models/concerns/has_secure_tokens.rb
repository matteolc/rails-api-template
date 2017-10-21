module HasSecureTokens	
    
    extend ActiveSupport::Concern

    class_methods do                    
        def has_secure_tokens(options = {})
        end
    end

    included do
        serialize :tokens, Array                      
    end  
    
    def generate_token        
        token = JsonWebToken.new.encode({
            username: username,
            csrf_token: SecureRandom.base64(32),
            iat: Time.now.utc,
            exp: 1.weeks.from_now.to_i,
            sub: id,
            roles: roles.map(&:name)
        })
        update_attributes(tokens: (tokens + [token]))
        token
    end    
  
    def revoke_token(token)  
        update_attributes(tokens: (tokens - [token]))        
    end 
  
    def has_valid_token?(token)

        tokens.each do |stored_token|
            return true if stored_token == token
        end

        false
    end     
    
end