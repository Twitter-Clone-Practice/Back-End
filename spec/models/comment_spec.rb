require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "Validations" do 
    it {should validate_presence_of :body }
  end

  describe "Relationsships" do
    it { should belong_to :post }
    it { should belong_to :user }
    it { should belong_to(:parent).optional }
    it { should have_many :replies }
  end
end
