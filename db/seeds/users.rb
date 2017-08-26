p "Creating users.."
admin = User.create password: ENV['ADMIN_SECRET'],
                    username: 'admin'                 
                   
admin.add_role :admin

user = User.create password: ENV['USER_SECRET'],
                   username: 'user'
                   
user.add_role :user

