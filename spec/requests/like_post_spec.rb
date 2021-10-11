require 'rails_helper'

describe 'liking a post' do
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

        @post = Post.create(
            user_id: @user_eternal.id,
            message: "cool"
        )
    end

    it 'should create a new post_info row when a user likes a post and it does not exist and add 1 to likes for post' do
        query_string = <<-GRAPHQL
            mutation {
                likePost(input: {
                    userId: #{@user_crimson.id}
                    postId: #{@post.id}
                }) {
                    success
                    errors
                }
            }
        GRAPHQL

        expect(@post.number_of_likes).to eq(0)
        
        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)
        
        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['likePost']).to be_a(Hash)
        expect(result['data']['likePost']['success']).to eq(true)
        expect(result['data']['likePost']['errors']).to be_a(Array)
        expect(result['data']['likePost']['errors']).to eq([])

        latest_post_info = PostInfo.last
        expect(latest_post_info.post_id).to eq(@post.id)
        expect(latest_post_info.user_id).to eq(@user_crimson.id)
        expect(latest_post_info.liked).to eq(true)

        @post.reload
        expect(@post.number_of_likes).to eq(1)
    end

    it 'should update the post_info row if a post_info exists for that user and post with likes as false' do
        query_string = <<-GRAPHQL
            mutation {
                likePost(input: {
                    userId: #{@user_crimson.id}
                    postId: #{@post.id}
                }) {
                    success
                    errors
                }
            }
        GRAPHQL

        post_info = PostInfo.create(user_id: @user_crimson.id, post_id: @post.id)

        expect(post_info.liked).to eq(false)
        expect(@post.number_of_likes).to eq(0)
        
        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)
        
        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['likePost']).to be_a(Hash)
        expect(result['data']['likePost']['success']).to eq(true)
        expect(result['data']['likePost']['errors']).to be_a(Array)
        expect(result['data']['likePost']['errors']).to eq([])

        post_info.reload
        expect(post_info.post_id).to eq(@post.id)
        expect(post_info.user_id).to eq(@user_crimson.id)
        expect(post_info.liked).to eq(true)

        @post.reload
        expect(@post.number_of_likes).to eq(1)
    end

    it 'should return an error if the post_info is already created and liked by the user and should not add 1 to likes' do
        query_string = <<-GRAPHQL
            mutation {
                likePost(input: {
                    userId: #{@user_crimson.id}
                    postId: #{@post.id}
                }) {
                    success
                    errors
                }
            }
        GRAPHQL

        post_info = PostInfo.create(user_id: @user_crimson.id, post_id: @post.id, liked: true)
        expect(@post.number_of_likes).to eq(0)

        expect(post_info.liked).to eq(true)
        
        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)
        
        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['likePost']).to be_a(Hash)
        expect(result['data']['likePost']['success']).to eq(false)
        expect(result['data']['likePost']['errors']).to be_a(Array)
        expect(result['data']['likePost']['errors']).to eq(["Post already liked by user"])

        @post.reload
        expect(@post.number_of_likes).to eq(0)
    end

    it 'should return an error if the post does not exist' do
        query_string = <<-GRAPHQL
            mutation {
                likePost(input: {
                    userId: #{@user_crimson.id}
                    postId: #{@post.id + 1}
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
        expect(result['data']['likePost']).to be_a(Hash)
        expect(result['data']['likePost']['success']).to eq(false)
        expect(result['data']['likePost']['errors']).to be_a(Array)
        expect(result['data']['likePost']['errors']).to eq(["User or post not found"])
    end

    it 'should return an error if the user does not exist' do
        query_string = <<-GRAPHQL
            mutation {
                likePost(input: {
                    userId: #{@user_crimson.id + 1}
                    postId: #{@post.id}
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
        expect(result['data']['likePost']).to be_a(Hash)
        expect(result['data']['likePost']['success']).to eq(false)
        expect(result['data']['likePost']['errors']).to be_a(Array)
        expect(result['data']['likePost']['errors']).to eq(["User or post not found"])
    end
end