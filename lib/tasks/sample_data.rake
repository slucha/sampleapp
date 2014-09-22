namespace :db  do
	desc "Fill Database with sample users"
	task populate: :environment do
		User.create!(name: "Example User",
					 email: "user@example.com",
					 password: "foobar",
					 password_confirmation: "foobar",
					 admin: true)
		50.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@faker.com"
			password = "password"
			User.create!(name: name,
						 email: email,
						 password: password,
						 password_confirmation: password)
		
		users = User.all(limit: 6)
    	40.times do
      	content = Faker::Lorem.sentence(5)
      	users.each { |user| user.microposts.create!(content: content) }
		end
		end
	end
end