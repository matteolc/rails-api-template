Faker::Number.between(51, 69).times do
    post = Post.create title: Faker::HarryPotter.location,
                       body: Faker::HarryPotter.quote,
                       author: Author.all.shuffle.first                 
    puts "Created post #{post.title}"
end