require 'rails_helper'

describe 'Create comment Mutation' do
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

        @post = Post.create!(user_id: @user_eternal.id, message: "First Post")
    end

    it 'should return a hash of a CommentType and empty errors array when a new comment is created' do
        query_string = <<-GRAPHQL
            mutation{
                newComment(input: {
                postId: #{ @post.id }
                userId: #{ @user_crimson.id }
                body: "First Comment"
                }) {
                comment{
                    postId
                    userId
                    parentId
                    body
                }
                errors
                } 
            }
        GRAPHQL

        expect(Comment.all.count).to eq(0)
        expect(@post.number_of_comments).to eq(0)
        
        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        @post.reload
        expect(Comment.all.count).to eq(1)
        expect(@post.number_of_comments).to eq(1)

        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['newComment']).to be_a(Hash)
        expect(result['data']['newComment']['comment']['postId']).to eq(@post.id)
        expect(result['data']['newComment']['comment']['userId']).to eq(@user_crimson.id)
        expect(result['data']['newComment']['comment']['parentId']).to eq(nil)
        expect(result['data']['newComment']['comment']['body']).to eq("First Comment")
        expect(result['data']['newComment']['errors']).to eq([])
    end

    it 'should return a hash of a CommentType and empty errors array when a new reply to a comment is created' do
        @post.number_of_comments += 1
        @post.save
        first_comment = Comment.create!(post_id: @post.id, user_id: @user_crimson.id, body: "Comments work")

        query_string = <<-GRAPHQL
            mutation{
                newComment(input: {
                postId: #{ @post.id }
                userId: #{ @user_crimson.id }
                parentId: #{ first_comment.id }
                body: "First comment reply"
                }) {
                comment{
                    postId
                    userId
                    parentId
                    body
                }
                errors
                } 
            }
        GRAPHQL

        expect(Comment.all.count).to eq(1)
        expect(@post.number_of_comments).to eq(1)
        
        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        @post.reload
        expect(Comment.all.count).to eq(2)
        expect(@post.number_of_comments).to eq(2)

        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['newComment']).to be_a(Hash)
        expect(result['data']['newComment']['comment']['postId']).to eq(@post.id)
        expect(result['data']['newComment']['comment']['userId']).to eq(@user_crimson.id)
        expect(result['data']['newComment']['comment']['parentId']).to eq(first_comment.id)
        expect(result['data']['newComment']['comment']['body']).to eq("First comment reply")
        expect(result['data']['newComment']['errors']).to eq([])
    end

    it 'should return an error if the parent comment does not exist' do
        @post.number_of_comments += 1
        @post.save
        first_comment = Comment.create!(post_id: @post.id, user_id: @user_crimson.id, body: "Comments work")

        query_string = <<-GRAPHQL
            mutation{
                newComment(input: {
                postId: #{ @post.id }
                userId: #{ @user_crimson.id }
                parentId: #{ first_comment.id + 1 }
                body: "First comment reply"
                }) {
                comment{
                    postId
                    userId
                    parentId
                    body
                }
                errors
                } 
            }
        GRAPHQL

        expect(Comment.all.count).to eq(1)
        expect(@post.number_of_comments).to eq(1)
        
        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        @post.reload
        expect(Comment.all.count).to eq(1)
        expect(@post.number_of_comments).to eq(1)

        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['newComment']).to be_a(Hash)
        expect(result['data']['newComment']['comment']).to eq(nil)
        expect(result['data']['newComment']['errors']).to eq(["Parent comment does not exists"])
    end

    it 'should return an error if the post does not exist' do
        query_string = <<-GRAPHQL
            mutation{
                newComment(input: {
                postId: #{ @post.id + 1 }
                userId: #{ @user_crimson.id }
                body: "First Comment"
                }) {
                comment{
                    id
                    postId
                    userId
                    parentId
                    body
                }
                errors
                } 
            }
        GRAPHQL
        
        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['newComment']).to be_a(Hash)
        expect(result['data']['newComment']['comment']).to eq(nil)
        expect(result['data']['newComment']['errors']).to eq(["Post or User does not exist"])
    end

    it 'should return an error if the user does not exist' do
        query_string = <<-GRAPHQL
            mutation{
                newComment(input: {
                postId: #{ @post.id }
                userId: #{ @user_crimson.id + 1 }
                body: "First Comment"
                }) {
                comment{
                    id
                    postId
                    userId
                    parentId
                    body
                }
                errors
                } 
            }
        GRAPHQL
        
        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)
        
        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['newComment']).to be_a(Hash)
        expect(result['data']['newComment']['comment']).to eq(nil)
        expect(result['data']['newComment']['errors']).to eq(["Post or User does not exist"])
    end
end