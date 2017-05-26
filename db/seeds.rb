User.create!(
    name:                  'Example User',
    email:                 'example@railstuorial.org',
    password:              'foobar',
    password_confirmation: 'foobar',
    admin:                  true
)

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
      admin:                 false
  )

end