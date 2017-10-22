class Account < User
    
    after_create :set_default_role
    def set_default_role
        self.add_role :regular
        self.save
    end

end