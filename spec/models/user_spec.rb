require 'rails_helper'

RSpec.describe User, type: :model do

	before :each do
		@user = FactoryGirl.build(:user)
	end

	subject { @user }

	it "responds to :email" do
		expect(@user).to respond_to :email
	end

	it "responds to :password" do
		expect(@user).to respond_to :password
	end

	it "responds to :password_confirmation" do
		expect(@user).to respond_to :password_confirmation
	end

	it "is valid" do
		expect(@user).to be_valid
	end

	it { should validate_presence_of(:email) }
	it { should validate_uniqueness_of(:email).case_insensitive }
	it { should validate_confirmation_of(:password) }
	it { should allow_value('example@domain.com').for(:email) }

	it { should respond_to(:auth_token) }
	it { should validate_uniqueness_of(:auth_token) }

	describe "#generate_authentication_token!" do
  	it "generates a unique token" do
  		Devise.stub(:friendly_token).and_return("auniquetoken123")
			@user.generate_authentication_token!
			expect(@user.auth_token).to eql "auniquetoken123"
		end

		it "generates another token when one already has been taken" do
  		existing_user = FactoryGirl.create(:user, auth_token: "auniquetoken123")
  		@user.generate_authentication_token!
		  expect(@user.auth_token).not_to eq existing_user.auth_token
		end
	end

end
