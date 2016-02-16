# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(username:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             activation_status: "active",
             admin: "true",
             created_at: Time.zone.now)
# unless User.find_by( email: "example@railstutorial.org" )             
50.times do |n|
  username  = Faker::Name.name
  email = "example-#{rand(100000)}@railstutorial.org"
  password = "password"
  User.create!(username:  username,
               email: email,
               password:              password,
               password_confirmation: password,
               activation_status: "active",
               created_at: Time.zone.now)
end
# end

# users = User.order(:created_at).take(1)
# 20.times do
  # content = Faker::Lorem.sentence(1)
  # users.each {|user| user.articles.create!(content: content, title: title, status: active)}
# end