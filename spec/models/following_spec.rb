require 'rails_helper'

RSpec.describe Following, type: :model do
  describe "Validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :following }
  end

  describe "Relationsships" do
    it { should belong_to :user }
    it { should belong_to(:following).class_name('User') }
  end
end
