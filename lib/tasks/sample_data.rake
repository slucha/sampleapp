namespace :db  do
	desc "Fill Database with sample users"
	task populate: :environment do
		User.create!(name: "Example User",
					 email: "user@example.com",
					 password: "foobar",
					 password_confirmation: "foobar",
					 admin: true)
		299.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@faker.com"
			password = "password"
			User.create!(name: name,
						 email: email,
						 password: password,
						 password_confirmation: password)
		end
	end
end