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

        @user_crimson = User.create(
            username: 'CrimsonGhost',
            email: 'crimson@gmail.com',
            password: '1234',
            password_confirmation: '1234',
            date_of_birth: '01/05/1998'
        )
    end

    it 'should succesfully add user as a new follower and who they are following' do
        query_string = <<-GRAPHQL
            mutation {
                followUser(input: {
                    primaryUserId: #{@user_eternal.id}
                    userToFollowId: #{@user_crimson.id}
                }) {
                    success
                    errors
                }
            }
        GRAPHQL
        
        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)
        
        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['followUser']).to be_a(Hash)
        expect(result['data']['followUser']['success']).to eq(true)
        expect(result['data']['followUser']['errors']).to be_a(Array)
        expect(result['data']['followUser']['errors']).to eq([])
    end

    it "should return an error if the user does not exist" do
        query_string = <<-GRAPHQL
            mutation {
                followUser(input: {
                    primaryUserId: #{@user_eternal.id}
                    userToFollowId: #{@user_crimson.id + 1}
                }) {
                    success
                    errors
                }
            }
        GRAPHQL
        
        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['followUser']).to be_a(Hash)
        expect(result['data']['followUser']['success']).to eq(nil)
        expect(result['data']['followUser']['errors']).to be_a(Array)
        expect(result['data']['followUser']['errors']).to eq(["A user does not exist!"])
    end

    it "should return an error if user already is following a user" do
        query_string = <<-GRAPHQL
            mutation {
                followUser(input: {
                    primaryUserId: #{@user_eternal.id}
                    userToFollowId: #{@user_crimson.id}
                }) {
                    success
                    errors
                }
            }
        GRAPHQL

        Follower.create(user_id: @user_eternal.id, follower_id: @user_crimson.id)

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)
        
        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['followUser']).to be_a(Hash)
        expect(result['data']['followUser']['success']).to eq(nil)
        expect(result['data']['followUser']['errors']).to be_a(Array)
        expect(result['data']['followUser']['errors']).to eq(["Already following user"])
    end
end