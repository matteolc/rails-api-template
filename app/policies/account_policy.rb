class AccountPolicy < ApplicationPolicy
	
  def create?
    true
  end

  def show?
    user.id === record.id
  end

  def update?
  	raise Pundit::NotAuthorizedError unless user.id === record.id
  end

  def destroy?
  	raise Pundit::NotAuthorizedError unless user.id === record.id
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  
end

