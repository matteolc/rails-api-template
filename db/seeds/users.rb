p "Creating users.."
admin = User.create email: 'admin@test.com',
                    password: '12345678',
                    username: 'admin'                 
                   
admin.add_role :admin

user = User.create email: 'user@test.com',
                password: '12345678',
                username: 'user'
                   
user.add_role :user

