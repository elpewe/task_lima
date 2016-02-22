# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# User.create!(username:  "elpewe",
             # email: "elpewe@gmail.com",
             # password:              "12345",
             # password_confirmation: "12345",
             # activation_status: "active",
             # admin: "true",
             # created_at: Time.zone.now)
             
# 20.times do |n|
  # username  = Faker::Name.name
  # email = "example-#{rand(100000)}@railstutorial.org"
  # password = "password"
  # User.create!(username:  username,
               # email: email,
               # password:              password,
               # password_confirmation: password,
               # activation_status: "active",
               # created_at: Time.zone.now)
# end

# users = User.order(:created_at).take(6)
# 20.times do
  # content = Faker::Lorem.sentence(5)
  # title = "title"
  # status= "active"
  # users.each { |user| user.articles.create!(content: content,
    # title: title, status: status) }
# end
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }