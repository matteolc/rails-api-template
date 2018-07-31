p "Creating users.."
admin = User.create email: Faker::Internet.email,
                    password: '123',
                    username: 'admin'                 
                   
admin.add_role :admin

guest = User.create email: Faker::Internet.email,
                   password: '123',
                   username: 'guest'
                   
guest.add_role :guest

