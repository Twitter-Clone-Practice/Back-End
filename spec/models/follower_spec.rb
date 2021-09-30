require 'rails_helper'

RSpec.describe Follower, type: :model do
  describe "Validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :follower }
  end

  describe "Relationsships" do
    it { should belong_to :user }
    it { should belong_to(:follower).class_name('User') }
  end
end
