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
        @liked_post = Like.create!(post_id: @post.id, user_id: @user_crimson.id)
    end

    it 'should be able to delete the like entry from the database' do
        query_string = <<-GRAPHQL
            mutation{
                unlikePost(input:{
                likeId: #{ @liked_post.id }
                }) {
                successful
                errors
                }
            }
        GRAPHQL

        expect(Like.all.count).to eq(1)

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(Like.all.count).to eq(0)
        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['unlikePost']).to be_a(Hash)
        expect(result['data']['unlikePost']['successful']).to eq(true)
        expect(result['data']['unlikePost']['errors']).to eq([])
    end

    it 'should be able to update number_of_likes from the post when unliked' do
        query_string = <<-GRAPHQL
            mutation{
                unlikePost(input:{
                likeId: #{ @liked_post.id }
                }) {
                successful
                errors
                }
            }
        GRAPHQL

        expect(@post.number_of_likes).to eq(1)

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        @post.reload
        expect(@post.number_of_likes).to eq(0)
        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['unlikePost']).to be_a(Hash)
        expect(result['data']['unlikePost']['successful']).to eq(true)
        expect(result['data']['unlikePost']['errors']).to eq([])
    end

    it 'should be able to update number_of_likes from the post when unliked' do
        query_string = <<-GRAPHQL
            mutation{
                unlikePost(input:{
                likeId: #{ @liked_post.id + 1 }
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
        expect(result['data']['unlikePost']).to be_a(Hash)
        expect(result['data']['unlikePost']['successful']).to eq(false)
        expect(result['data']['unlikePost']['errors']).to eq(['Unable to find ID for like'])
    end
end