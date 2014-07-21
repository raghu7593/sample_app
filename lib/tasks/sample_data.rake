namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_relationships
    make_micropost
    populate
  end
end

def make_users
  admin = User.create!(name:     "Example User",
                       email:    "example@railstutorial.org",
                       password: "foobar",
                       password_confirmation: "foobar")
  admin.toggle!(:admin)
  49.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end

def make_micropost
  k = rand(1..50)
  user = User.find(k)
  content = Faker::Lorem.sentence(5)
  user.microposts.create!(content: content)
  Points.create(user_id: k, score: 5, activity: "MC")
end

def make_comment
  k = rand(1..50)
  j = Micropost.count
  l = rand(1..j)
  content = Faker::Lorem.sentence(5)
  micropost = Micropost.find(l)
  micropost.comments.create!(content: content, user_id: k)
  Points.create(user_id: k, score: 3, activity: "CC")
end

def populate
  4000.times do
    k = rand(1..2)
    if k==1
      make_micropost
    else
      make_comment
    end
  end
end