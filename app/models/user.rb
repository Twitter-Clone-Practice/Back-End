class User < ApplicationRecord
    has_secure_password
    
    has_many :followings
    has_many :following, through: :followings
    has_many :posts, dependent: :destroy

    has_many :followers
    has_many :follower, through: :followers

    has_many :likes, dependent: :destroy

    validates :username, :email, uniqueness: true, presence: true
    validates :password, :date_of_birth, presence: true
end
