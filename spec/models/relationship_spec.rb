require 'spec_helper'

describe Relationship do

	describe "follower methods" do
		it { should respond_to(:follower) }
		it { should respond_to(:followed) }
		its(:follower) { should eq follower }
	  	its(:followed) { should eq followed }
  	end

	describe "when follower is not present" do
		before { relationship.follower_id = nil }
		it { should_not be_valid }
	end

	describe "when followed ia not present" do
		before { relationship.followed_id = nil }
		it { should_not be_valid }
	end
end