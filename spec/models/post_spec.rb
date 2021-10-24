require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "Validations" do 
    it {should validate_presence_of :message }
  end

  describe "Relationsships" do
    it { should belong_to :user }
    it { should have_many :comments }
    it { should have_many :likes }
  end

  describe "Methods" do
    it 'exists? should return true if the post exists in the database' do
      user_eternal = User.create(
        username: 'EternalFlame',
        email: 'eternal@gmail.com',
        password: '1234',
        password_confirmation: '1234',
        date_of_birth: '05/14/1999'
      )

      post = Post.create!(user_id: user_eternal.id, message: "First Post")

      expect(Post.exists?(post.id)).to eq(true)
    end

    it 'exists? should return false if the post does not exists in the database' do
      user_eternal = User.create(
        username: 'EternalFlame',
        email: 'eternal@gmail.com',
        password: '1234',
        password_confirmation: '1234',
        date_of_birth: '05/14/1999'
      )

      post = Post.create!(user_id: user_eternal.id, message: "First Post")

      expect(User.exists?(post.id + 1)).to eq(false)
    end

    it 'add_to_num_of_comments should be able to add one to the posts number of comments' do
      user_eternal = User.create(
        username: 'EternalFlame',
        email: 'eternal@gmail.com',
        password: '1234',
        password_confirmation: '1234',
        date_of_birth: '05/14/1999'
      )

      post = Post.create!(user_id: user_eternal.id, message: "First Post")
      expect(post.number_of_comments).to eq(0)

      Post.add_to_num_of_comments(post.id)
      post.reload
      expect(post.number_of_comments).to eq(1)
    end
  end
end
