# frozen_string_literal: true

class Api::V1::UserResource < Api::V1::ApiResource
    
    VIRTUAL_ATTRIBUTES = %i[password_confirmation roles].freeze  

    attributes *User.attribute_names.map(&:to_sym) -
                %i[id] +
                VIRTUAL_ATTRIBUTES

    def self.fields
      super - [:password, :password_confirmation]
    end              
  
    def password=(new_password)
      @model.password = new_password if new_password
    end    
    
    def password_confirmation=(new_password)
      @model.password_confirmation = new_password if new_password
    end 
  
    def roles
      @model.roles.pluck(:name)
    end
  
    def roles=(new_roles)
      current_roles = @model.roles.pluck(:name)
      new_roles.each do |new_role|
        @model.add_role(new_role)
      end
      (current_roles - new_roles).each do |role|
        @model.remove_role(role)
      end
    end
  
    def updatable_fields
      super - [:password, :password_confirmation]
    end  
  
    filters :email,
            :username

end
  