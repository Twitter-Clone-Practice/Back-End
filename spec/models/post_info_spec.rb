require 'rails_helper'

RSpec.describe PostInfo, type: :model do
  describe "Relationsships" do
    it { should belong_to :user }
    it { should belong_to :post }
  end
end
