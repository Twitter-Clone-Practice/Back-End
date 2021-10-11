class Post < ApplicationRecord
  belongs_to :user
  has_many :post_infos

  validates :message, presence: true
end
