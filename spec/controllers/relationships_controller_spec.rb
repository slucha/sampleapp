require 'spec_helper'

describe RelationshipsController do
	let(:user) { FactoryGirl.create(:user) }
	let(:other_user) { FactoryGirl.create(:user) }

	before { sign_in user, no_capybara: true }

	describe "creating a relationship with Ajax" do

		it "should increment the Relationship count" do
			expect do
				xhr :post, :create, relationship: {followed_id: other_user.id}
			end.to change(Relationship, :count).by(1)
		end

		it "should respond with sucess" do
			xhr :post, :create, relationship: { followed_id: other_user.id }
			expect(respond).to be_sucess
		end
	end

	describe "destroying a relationship with Ajax" do
		before { user.follow!(other_user) }
		let(:relationship) do
			user.relationship.find_by(:followed_id, other_user.id)
		end

		it "should decrement the Relationship count" do
			expect do
				xhr :delete, :destroy, id: relationship.id
			end.to change(Relationship, :count).by(-1)
		end

		it "should respond with sucess" do
			xhr :delete, :destroy, id: relationship.id
			expect(response).to be_sucess
		end
	end
end