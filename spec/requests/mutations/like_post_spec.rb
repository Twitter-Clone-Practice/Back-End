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
    end

    it "should be able to create a new like entry in the like table" do
        query_string = <<-GRAPHQL
            mutation{
                likePost(input: {
                    postId: #{ @crimson_post.id }
                    userId: #{ @user_eternal.id }
                }) {
                    successful
                    errors
                }
                }
        GRAPHQL

        expect(Like.all.count).to eq(1)

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(Like.all.count).to eq(2)
        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['likePost']).to be_a(Hash)
        expect(result['data']['likePost']['successful']).to eq(true)
        expect(result['data']['likePost']['errors']).to eq([])
    end

    it "should return an error if post does not exist" do
        query_string = <<-GRAPHQL
            mutation{
                likePost(input: {
                    postId: #{ @crimson_post.id + 1 }
                    userId: #{ @user_eternal.id }
                }) {
                    successful
                    errors
                }
                }
        GRAPHQL

        expect(Like.all.count).to eq(1)

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(Like.all.count).to eq(1)
        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['likePost']).to eq(nil)
        expect(result['errors']).to be_a(Array)
        expect(result['errors'][0]['message']).to eq("Post must exist")
    end

    it "should return an error if user does not exist" do
        query_string = <<-GRAPHQL
            mutation{
                likePost(input: {
                    postId: #{ @crimson_post.id }
                    userId: #{ @user_eternal.id + 30 }
                }) {
                    successful
                    errors
                }
                }
        GRAPHQL

        expect(Like.all.count).to eq(1)

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(Like.all.count).to eq(1)
        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['likePost']).to eq(nil)
        expect(result['errors']).to be_a(Array)
        expect(result['errors'][0]['message']).to eq("User must exist")
    end

    it "should return an error if User and Post does not exist" do
        query_string = <<-GRAPHQL
            mutation{
                likePost(input: {
                    postId: #{ @crimson_post.id + 1}
                    userId: #{ @user_eternal.id + 30 }
                }) {
                    successful
                    errors
                }
                }
        GRAPHQL

        expect(Like.all.count).to eq(1)

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(Like.all.count).to eq(1)
        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['likePost']).to eq(nil)
        expect(result['errors']).to be_a(Array)
        expect(result['errors'][0]['message']).to eq("Post must exist, User must exist")
    end
end