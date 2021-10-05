require 'rails_helper'

describe 'New follower' do
    before :each do
        @user_eternal = User.create(
            username: 'EternalFlame',
            email: 'eternal@gmail.com',
            password: '1234',
            password_confirmation: '1234',
            date_of_birth: '05/14/1999'
        )

        @user_Crimson = User.create(
            username: 'CrimsonGhost',
            email: 'crimson@gmail.com',
            password: '1234',
            password_confirmation: '1234',
            date_of_birth: '01/05/1998'
        )
    end

    it 'should succesfully add user as a new follower and who they are following' do
        
    end
end