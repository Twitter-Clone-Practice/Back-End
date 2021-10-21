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

  describe 'Methods' do
    it 'exists? should return true if the Comment exists in the database' do
      user_eternal = User.create(
        username: 'EternalFlame',
        email: 'eternal@gmail.com',
        password: '1234',
        password_confirmation: '1234',
        date_of_birth: '05/14/1999'
      )

      user_crimson = User.create(
        username: 'CrimsonGhost',
        email: 'crimson@gmail.com',
        password: '1234',
        password_confirmation: '1234',
        date_of_birth: '05/14/1999'
      )

      post = Post.create!(user_id: user_eternal.id, message: "First Post")
      first_comment = Comment.create!(post_id: post.id, user_id: user_crimson.id, body: "Comments work")

      expect(Comment.exists?(first_comment.id)).to eq(true)
    end

    it 'exists? should return false if the Comment does not exists in the database' do
      user_eternal = User.create(
        username: 'EternalFlame',
        email: 'eternal@gmail.com',
        password: '1234',
        password_confirmation: '1234',
        date_of_birth: '05/14/1999'
      )

      user_crimson = User.create(
        username: 'CrimsonGhost',
        email: 'crimson@gmail.com',
        password: '1234',
        password_confirmation: '1234',
        date_of_birth: '05/14/1999'
      )

      post = Post.create!(user_id: user_eternal.id, message: "First Post")
      first_comment = Comment.create!(post_id: post.id, user_id: user_crimson.id, body: "Comments work")

      expect(Comment.exists?(first_comment.id + 1)).to eq(false)
    end
  end
end
