class UserPolicy < ApplicationPolicy
  
 
   def index?
    raise Pundit::NotAuthorizedError unless user.has_any_role?(:admin)
    true
   end
 
   def create?
    raise Pundit::NotAuthorizedError unless user.has_any_role?(:admin)
    true
   end
 
   def show?
    raise Pundit::NotAuthorizedError unless user.has_any_role?(:admin)
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
    
end