Faker::Number.between(21, 29).times do
    author = Author.create name: Faker::HarryPotter.character
    puts "Created author #{author.name}"
end