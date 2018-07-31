class UserPolicy < ApplicationPolicy  
 
   def index?
    user.has_any_role?(:admin) ?
      true :
      raise Pundit::NotAuthorizedError
   end
 
   def create?
    user.has_any_role?(:admin) ?
      true :
      raise Pundit::NotAuthorizedError
   end
 
   def show?
    user.has_any_role?(:admin) ?
      true :
      raise Pundit::NotAuthorizedError
   end
 
   def update?
    user.has_any_role?(:admin) ?
      true :
      raise Pundit::NotAuthorizedError
   end
 
   def destroy?
    user.has_any_role?(:admin) ?
      true :
      raise Pundit::NotAuthorizedError
   end
    
end