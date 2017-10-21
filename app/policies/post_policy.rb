class PostPolicy < ApplicationPolicy
    
   
     def index?
       true
     end
   
     def create?
       true
     end
   
     def show?
       true
     end
   
     def update?
         raise Pundit::NotAuthorizedError unless user
       return record
     end
   
     def destroy?
         raise Pundit::NotAuthorizedError unless user
       return record 
     end
   
     class Scope < Scope
       def resolve
         scope.all
       end
     end
   
   end
   
   