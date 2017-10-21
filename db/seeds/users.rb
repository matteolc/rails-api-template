p "Creating users.."
admin = User.create email: Faker::Internet.email,
                    password: '123',
                    username: 'admin'                 
                   
admin.add_role :admin

user = User.create email: Faker::Internet.email,
                   password: '123',
                   username: 'user'
                   
user.add_role :user

