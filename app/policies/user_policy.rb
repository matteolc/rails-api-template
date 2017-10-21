class UserPolicy < ApplicationPolicy
    
   
     def index?
       user.has_any_role?(:admin)
     end
   
     def create?
        user.has_any_role?(:admin)
     end
   
     def show?
        user.has_any_role?(:admin)
     end
   
     def update?
        user.has_any_role?(:admin)
     end
   
     def destroy?
        user.has_any_role?(:admin)
     end
      
   end