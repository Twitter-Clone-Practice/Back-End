require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    it { should validate_presence_of :username }
    it { should validate_presence_of :email }
    it { should validate_presence_of :date_of_birth }
    it { should validate_presence_of :password }
  end

  describe "Relations" do
    it {should have_many :followings}
    it {should have_many :followers}
  end
end
