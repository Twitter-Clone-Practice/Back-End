require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    it { should validate_presence_of :username }
    it { should validate_presence_of :email }
    it { should validate_presence_of :date_of_birth }
    it { should validate_presence_of :password }
  end

  describe "Relations" do
    it { should have_many :followings }
    it { should have_many :followers }
    it { should have_many :posts }
    it { should have_many :likes }
  end

  describe "Methods" do
    it 'should return true if the user exists in the database' do
      user_eternal = User.create(
        username: 'EternalFlame',
        email: 'eternal@gmail.com',
        password: '1234',
        password_confirmation: '1234',
        date_of_birth: '05/14/1999'
      )

      expect(User.exists?(user_eternal.id)).to eq(true)
    end

    it 'should return false if the user does not exists in the database' do
      user_eternal = User.create(
        username: 'EternalFlame',
        email: 'eternal@gmail.com',
        password: '1234',
        password_confirmation: '1234',
        date_of_birth: '05/14/1999'
      )

      expect(User.exists?(user_eternal.id + 1)).to eq(false)
    end
  end
end
