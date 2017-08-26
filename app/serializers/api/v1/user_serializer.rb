module Api::V1
  class UserSerializer < ActiveModel::Serializer
  	
    attributes *User.attribute_names.map(&:to_sym),
               :roles
     
    def roles
      object.roles.map(&:name) 
    end
    
  end
end
