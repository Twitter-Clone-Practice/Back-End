class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :message, presence: true

  def self.add_to_num_of_comments(post_id)
    post = self.find_by_id(post_id)

    post.number_of_comments += 1

    post.save
  end

  def self.subtract_from_num_of_comments(post_id, comments_to_subtract = 1)
    post = self.find_by_id(post_id)
    
    post.number_of_comments -= comments_to_subtract

    post.save
  end

  def self.add_to_num_of_likes(post_id)
    post = self.find_by_id(post_id)

    post.number_of_likes += 1

    post.save
  end

  def self.subtract_from_num_of_likes(post_id)
    post = self.find_by_id(post_id)
    
    post.number_of_likes -= 1

    post.save
  end  
end
