require 'spec_helper'

describe "UserPages" do

    
    subject { page }

      describe "index" do
	    before do
	      sign_in FactoryGirl.create(:user)
	      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
	      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
	      visit users_path
	    

	    it { should have_title('All users') }
	    it { should have_content('All users') }

	    it "should list each user" do
	      User.all.each do |user|
	        expect(page).to have_selector('li', text: user.name)
	      end
	    end
	  end


	  describe "following/followers" do
	    let(:user) { FactoryGirl.create(:user) }
	    let(:other_user) { FactoryGirl.create(:user) }
	    before { user.follow!(other_user) }

    describe "followed users" do
     	before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_title(full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_title(full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
	end
end

	  describe "pagination" do
	  	before(:all) { 30.times {FactoryGirl.create(:user) } }
	  	after(:all) { User.delete_all }

	  	it { should have_selector('div.pagination') }
	 

    describe "signup page" do
    	before { visit signup_path }

    	it { should have_content('Sign up')}
    	it { should have_title(full_title('Sign up')) }
    end 

    describe "edit" do
    	let(:user) { FactoryGirl.create(:user) }
    	before do
    		signin_user
    		visit edit_user_path(user)
    	end
    
    
	    describe "page" do
	    it { should have_content("Update your Profile") }	
	    it { should have_title("Edit User") }	
	    it { should have_link('change', herf: 'http://gravatar.com/emails') }
	    end

	    describe "with invalid information" do
	    	before { click_button("Save changes") }

	    	it { should have_content('error') }
	    end	

	    describe "with valid information" do
	    	let(:new_name) { "New Name"}
	    	let(:new_email) { "New Email"}
	    	before do
	    		fill_in "Name",             with: new_name
		        fill_in "Email",            with: new_email
		        fill_in "Password",         with: user.password
		        fill_in "Confirm Password", with: user.password
		        click_button "Save changes"
      		end

      		it { should have_title(new_name) }
      		it { should have_selector('div.alert.alert-success') }
	      	it { should have_link('Sign out', href: signout_path) }
	      	specify { expect(user.reload.name).to  eq new_name }
	      	specify { expect(user.reload.email).to eq new_email }
	    end
		
		describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
			before { sign_in user, no_capybara: true }
		

			describe "submitting a GET request to the User#edit action" do
				before { get edit_user_path(wrong_user) }
				specify { expect(response.body).not_to match(full_title('Edit user')) }
				specify { expect(response).to redirect_to(root_url)}
			end

			describe "submitting a PATCH request to the User#update action" do
				before { patch user_path(wrong_user) }
				specify { expect(response).to redirect_to(root_url) }
			end	
		end	
	end    
end
end