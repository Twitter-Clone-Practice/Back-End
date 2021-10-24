require 'rails_helper'

describe 'Fetch user liked Posts' do
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
            date_of_birth: '05/14/1999'
        )

        @post = Post.create!(user_id: @user_eternal.id, message: "First Post", number_of_comments: 2, number_of_likes: 1)
        @second_post = Post.create!(user_id: @user_eternal.id, message: "Second Post", number_of_comments: 2, number_of_likes: 1)
        @crimson_post = Post.create!(user_id: @user_crimson.id, message: "Cool", number_of_comments: 0, number_of_likes: 1)
        
        Like.create!(post_id: @post.id, user_id: @user_crimson.id)
        Like.create!(post_id: @second_post.id, user_id: @user_crimson.id)
        Like.create!(post_id: @crimson_post.id, user_id: @user_eternal.id)
    end

    it "Can fetch user_eternals liked posts" do
        query_string = <<-GRAPHQL
            query{
                fetchUserLikedPosts(userId:#{@user_eternal.id}){
                id
                message
                numberOfLikes
                numberOfComments
                }
            }
        GRAPHQL

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['fetchUserLikedPosts']).to be_a(Array)
        expect(result['data']['fetchUserLikedPosts'].count).to eq(1)
        expect(result['data']['fetchUserLikedPosts'][0]).to be_a(Hash)
        expect(result['data']['fetchUserLikedPosts'][0]['id']).to eq(@crimson_post.id.to_s)
        expect(result['data']['fetchUserLikedPosts'][0]['message']).to eq(@crimson_post.message)
        expect(result['data']['fetchUserLikedPosts'][0]['numberOfLikes']).to eq(@crimson_post.number_of_likes)
        expect(result['data']['fetchUserLikedPosts'][0]['numberOfComments']).to eq(@crimson_post.number_of_comments)
    end

    it "Can fetch user_crimson liked posts" do
        query_string = <<-GRAPHQL
            query{
                fetchUserLikedPosts(userId:#{@user_crimson.id}){
                id
                message
                numberOfLikes
                numberOfComments
                }
            }
        GRAPHQL

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)
        
        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['fetchUserLikedPosts']).to be_a(Array)
        expect(result['data']['fetchUserLikedPosts'].count).to eq(2)
        expect(result['data']['fetchUserLikedPosts'][0]).to be_a(Hash)
        expect(result['data']['fetchUserLikedPosts'][0]['id']).to eq(@post.id.to_s)
        expect(result['data']['fetchUserLikedPosts'][0]['message']).to eq(@post.message)
        expect(result['data']['fetchUserLikedPosts'][0]['numberOfLikes']).to eq(@post.number_of_likes)
        expect(result['data']['fetchUserLikedPosts'][0]['numberOfComments']).to eq(@post.number_of_comments)
        
        expect(result['data']['fetchUserLikedPosts'][1]).to be_a(Hash)
        expect(result['data']['fetchUserLikedPosts'][1]['id']).to eq(@second_post.id.to_s)
        expect(result['data']['fetchUserLikedPosts'][1]['message']).to eq(@second_post.message)
        expect(result['data']['fetchUserLikedPosts'][1]['numberOfLikes']).to eq(@second_post.number_of_likes)
        expect(result['data']['fetchUserLikedPosts'][1]['numberOfComments']).to eq(@second_post.number_of_comments)
    end
end