# frozen_string_literal: true

class Account < User
    
    after_create :set_default_role
    def set_default_role
        self.add_role :guest
        self.save
    end

end