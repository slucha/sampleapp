FactoryGirl.define do
	factory :user do
		name "Hans Peter"
		email "hans@peter.de"
		password "wurst12345wasser"
		password_confirmation "wurst12345wasser"
	end
end
