class AccountPolicy < ApplicationPolicy
	
  def create?
    true
  end

  def show?
    user.id === record.id ?
      true :
      raise Pundit::NotAuthorizedError
  end

  def update?
    user.id === record.id ?
      true :
      raise Pundit::NotAuthorizedError
  end

  def destroy?
    user.id === record.id ?
      true :
      raise Pundit::NotAuthorizedError
  end
 
end

