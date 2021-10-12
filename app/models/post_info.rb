class PostInfo < ApplicationRecord
  belongs_to :post
  belongs_to :user

  has_many :comments, class_name: 'Comment', foreign_key: :post_info_id

  validates_uniqueness_of :user, scope: :post_id
end
