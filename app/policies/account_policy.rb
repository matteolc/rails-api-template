class AccountPolicy < ApplicationPolicy
	
  def create?
    true
  end

  def show?
    raise Pundit::NotAuthorizedError unless user.id === record.id
    true
  end

  def update?
    raise Pundit::NotAuthorizedError unless user.id === record.id
    true
  end

  def destroy?
    raise Pundit::NotAuthorizedError unless user.id === record.id
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  
end

