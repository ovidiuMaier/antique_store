User.create!(name:  "Example User",
             email: "example@gmail.com",
             password:              "secret",
             password_confirmation: "secret",
             picture: File.new("app/assets/images/profile_pictures/default_profile.jpg"))

35.times do |n|
  name  = Faker::Name.name
  email = "example#{n+1}@gmail.com"
  password = "secret"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               picture: File.new("app/assets/images/profile_pictures/default_profile.jpg")
               )
end
