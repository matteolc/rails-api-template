class UserPolicy < ApplicationPolicy
	
  def create?
    return Regular.new(record)
  end

  def show?
    user.has_any_role?(:admin) ? Admin.new(record) : Regular.new(record)    
  end

  def update?
  	raise Pundit::NotAuthorizedError unless user
    return Regular.new(record)
  end

  def destroy?
  	raise Pundit::NotAuthorizedError unless user
    return Regular.new(record)    
  end

  class Scope < Scope
    def resolve
      user.has_any_role?(:admin) ? Admin.new(scope, User) : Regular.new(scope, User) 
    end
  end

  class Admin < FlexiblePermissions::Base
    class Fields < self::Fields
      def permitted
        super
      end
    end

    class Includes < self::Includes
      def default
        []
      end
    end
  end

  class Regular < Admin
    class Fields < self::Fields
      def permitted
        super - [
          :created_at,
          :updated_at
        ]
      end
    end
  end
  
end

