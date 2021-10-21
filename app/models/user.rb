class User < ApplicationRecord
    has_secure_password
    
    has_many :followings
    has_many :following, through: :followings
    has_many :posts

    has_many :followers
    has_many :follower, through: :followers

    validates :username, :email, uniqueness: true, presence: true
    validates :password, :date_of_birth, presence: true
end
