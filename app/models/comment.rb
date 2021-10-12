class Comment < ApplicationRecord
  belongs_to :post_info, class_name: 'PostInfo'
  has_one :post, through: :post_info
  has_one :user, through: :post_info
end
