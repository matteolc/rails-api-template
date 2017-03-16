# == Schema Information
#
# Table name: users
#
#  id                 :uuid             not null, primary key
#  provider           :string           default("email"), not null
#  uid                :string           default(""), not null
#  username           :string           not null
#  encrypted_password :string           default(""), not null
#  sign_in_count      :integer          default(0), not null
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :string
#  last_sign_in_ip    :string
#  name               :string
#  nickname           :string
#  image              :string
#  email              :string
#  tokens             :json
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_users_on_email                  (email)
#  index_users_on_uid_and_provider       (uid,provider) UNIQUE
#  index_users_on_username_and_provider  (username,provider) UNIQUE
#

module Api::V1
  class UserSerializer < ActiveModel::Serializer
  	
    attributes *User.attribute_names.map(&:to_sym),
               :roles
     
    def roles
      object.roles.map(&:name) 
    end
    
  end
end
