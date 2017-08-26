p "Creating users.."
admin = User.create email: 'admin@test.com',
                    password: ENV['ADMIN_SECRET'],
                    username: 'admin'                 
                   
admin.add_role :admin

user = User.create email: 'user@test.com',
                password: ENV['USER_SECRET'],
                username: 'user'
                   
user.add_role :user

