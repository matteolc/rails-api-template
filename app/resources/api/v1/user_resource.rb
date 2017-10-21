class Api::V1::UserResource < Api::V1::ApiResource
    
    attributes  :email,
                :username,
                :password,
                :roles

    def password=(new_password)
        @model.password = new_password if new_password
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

    filters :email

end