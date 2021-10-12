require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "Relationships" do
    it { should belong_to :post_info }
    it { should have_one :post }
    it { should have_one :user }
  end
end
