require 'rails_helper'

describe 'Unfollow' do
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

      Following.create!(
        user_id: @user_eternal.id,
        following_id: @user_crimson.id
      )
      Follower.create!(
        user_id: @user_crimson.id,
        follower_id: @user_eternal.id
      )
  end

  it 'should succesfully delete user as a follower and who they are following' do
      query_string = <<-GRAPHQL
          mutation {
              unfollowUser(input: {
                  primaryUserId: #{@user_eternal.id}
                  userToUnfollowId: #{@user_crimson.id}
              }) {
                  successful
                  errors
              }
          }
      GRAPHQL
      
      post graphql_path, params: { query: query_string }
      result = JSON.parse(response.body)

      expect(result).to be_a(Hash)
      expect(result['data']).to be_a(Hash)
      expect(result['data']['unfollowUser']).to be_a(Hash)
      expect(result['data']['unfollowUser']['successful']).to eq(true)
      expect(result['data']['unfollowUser']['errors']).to be_a(Array)
      expect(result['data']['unfollowUser']['errors']).to eq([])
      
      @user_eternal.reload
      @user_crimson.reload

      expect(@user_eternal.following).to eq([])
      expect(@user_eternal.follower).to eq([])
      expect(@user_crimson.follower).to eq([])
      expect(@user_crimson.following).to eq([])
  end

  it 'should return error if user are the same' do
    query_string = <<-GRAPHQL
          mutation {
              unfollowUser(input: {
                  primaryUserId: #{@user_eternal.id }
                  userToUnfollowId: #{@user_eternal.id}
              }) {
                  successful
                  errors
              }
          }
      GRAPHQL
      
      post graphql_path, params: { query: query_string }
      result = JSON.parse(response.body)

      expect(result).to be_a(Hash)
      expect(result['data']).to be_a(Hash)
      expect(result['data']['unfollowUser']).to be_a(Hash)
      expect(result['data']['unfollowUser']['successful']).to eq(false)
      expect(result['data']['unfollowUser']['errors']).to be_a(Array)
      expect(result['data']['unfollowUser']['errors']).to eq(["User id's are the same"])
  end

  it 'should return error if user does not exist' do
    query_string = <<-GRAPHQL
          mutation {
              unfollowUser(input: {
                  primaryUserId: #{@user_eternal.id }
                  userToUnfollowId: #{@user_crimson.id + 1}
              }) {
                  successful
                  errors
              }
          }
      GRAPHQL
      
      post graphql_path, params: { query: query_string }
      result = JSON.parse(response.body)

      expect(result).to be_a(Hash)
      expect(result['data']).to be_a(Hash)
      expect(result['data']['unfollowUser']).to be_a(Hash)
      expect(result['data']['unfollowUser']['successful']).to eq(false)
      expect(result['data']['unfollowUser']['errors']).to be_a(Array)
      expect(result['data']['unfollowUser']['errors']).to eq(["User not found"])
  end

  it 'should return error if user does not exist' do
    query_string = <<-GRAPHQL
          mutation {
              unfollowUser(input: {
                  primaryUserId: #{@user_eternal.id + 4}
                  userToUnfollowId: #{@user_crimson.id }
              }) {
                  successful
                  errors
              }
          }
      GRAPHQL
      
      post graphql_path, params: { query: query_string }
      result = JSON.parse(response.body)

      expect(result).to be_a(Hash)
      expect(result['data']).to be_a(Hash)
      expect(result['data']['unfollowUser']).to be_a(Hash)
      expect(result['data']['unfollowUser']['successful']).to eq(false)
      expect(result['data']['unfollowUser']['errors']).to be_a(Array)
      expect(result['data']['unfollowUser']['errors']).to eq(["User not found"])
  end
end