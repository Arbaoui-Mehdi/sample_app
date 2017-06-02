User.create!(
    name:                  'John Doe',
    email:                 'whithat87@gmail.com',
    password:              'foobar',
    password_confirmation: 'foobar',
    admin:                  true,
    activated:              true,
    activated_at:           Time.zone.now
)

#
#
# Create 99 users
99.times do |n|
  name     = Faker::Name::name
  email    = Faker::Internet::email
  password = 'foobar'
  User.create!(
      name:                  name,
      email:                 email,
      password:              password,
      password_confirmation: password,
      admin:                 false,
      activated:             true,
      activated_at:          Time.zone.now
  )
end

#
#
# Create 50 Microposts for each user
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each {
    |user| user.microposts.create!(content: content)
  }
end

#
#
# Following Relationships
users     = User.all
user      = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }