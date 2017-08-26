p "Creating users.."
admin = User.create email: Faker::Internet.email,
                    password: ENV['ADMIN_SECRET'],
                    username: 'admin'                 
                   
admin.add_role :admin

user = User.create email: Faker::Internet.email,
                   password: ENV['USER_SECRET'],
                   username: 'user'
                   
user.add_role :user

