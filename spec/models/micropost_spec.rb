require 'spec_helper'

describe Micropost do
  let(:user) {FactoryGirl.create(:user) }
  before do
  	#This code is not idiomatically correct
  	@micropost = user.micropost.build(content: "Lorem Ipsum" )
  end

  subject { @micropost }

  it { schould respond_to(:content) }
  it { schould respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
  	before { @micropost.user_id = nil }
  	it {should_not be_valid }
  end

end
