class PostPolicy < ApplicationPolicy
  
 
   def index?
    raise Pundit::NotAuthorizedError unless user
    true
   end
 
   def create?
    raise Pundit::NotAuthorizedError unless user
    true
   end
 
   def show?
    raise Pundit::NotAuthorizedError unless user
    true
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
 
 