class User < ApplicationRecord
    has_secure_password
    
    has_many :followings
    has_many :users, through: :followings

    has_many :followers
    has_many :users, through: :followers

    validates :username, :email, uniqueness: true, presence: true
    validates :password, :date_of_birth, presence: true
end
