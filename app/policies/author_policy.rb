class AuthorPolicy < ApplicationPolicy
    
    def index?
      true
    end
  
    def create?
      raise Pundit::NotAuthorizedError unless user.has_any_role?(:admin)
    end
  
    def show?
      false
    end
  
    def update?
        raise Pundit::NotAuthorizedError unless user
        true
    end
  
    def destroy?
        raise Pundit::NotAuthorizedError unless user
        true
    end
  
    class Scope < Scope
      def resolve
        scope.all
      end
    end
  
    
  end
  
  