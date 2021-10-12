class Post < ApplicationRecord
  belongs_to :user
  has_many :post_infos
  has_many :comments, through: :post_infos

  validates :message, presence: true
end
