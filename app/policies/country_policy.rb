# frozen_string_literal: true

class CountryPolicy < ApplicationPolicy
    def index?
      raise Pundit::NotAuthorizedError unless user
      true
    end
  
    def create?
      false
    end
  
    def show?
      raise Pundit::NotAuthorizedError unless user
      true
    end
  
    def update?
      user.has_any_role?(:admin) ?
        true :
        (raise Pundit::NotAuthorizedError)
    end
  
    def destroy?
      false
    end
end