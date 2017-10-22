class AuthorPolicy < ApplicationPolicy
  
  def index?
    true
  end

  def create?
    raise Pundit::NotAuthorizedError unless user.has_any_role?(:admin)
  end

  def show?
    true
  end

  def update?
      raise Pundit::NotAuthorizedError unless user.has_any_role?(:admin)
      true
  end

  def destroy?
      raise Pundit::NotAuthorizedError unless user.has_any_role?(:admin)
      true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  
end

