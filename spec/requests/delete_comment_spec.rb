require 'rails_helper'

describe 'Delete comment Mutation' do
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

        @post = Post.create!(user_id: @user_eternal.id, message: "First Post", number_of_comments: 3)
        @first_comment = Comment.create!(post_id: @post.id, user_id: @user_crimson.id, body: "Comments work")
        @reply_to_comment = Comment.create!(post_id: @post.id, user_id: @user_eternal.id, parent_id: @first_comment.id, body: "Replies Work")
        @second_comment = Comment.create!(post_id: @post.id, user_id: @user_crimson.id, body: "Comments work again")
    end

    it "should be able to delete a single comment and update the number_of_comments for the post" do
        query_string = <<-GRAPHQL
            mutation{
                deleteComment(input: {
                commentId: #{@second_comment.id}
                }) {
                successful
                errors
                }
            }
        GRAPHQL

        expect(Comment.all.count).to eq(3)
        expect(@post.number_of_comments).to eq(3)

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(Comment.all.count).to eq(2)
        @post.reload
        expect(@post.number_of_comments).to eq(2)

        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['deleteComment']).to be_a(Hash)
        expect(result['data']['deleteComment']['successful']).to eq(true)
        expect(result['data']['deleteComment']['errors']).to eq([])
    end

    it "should be able to delete a a comment and its replies and update the number_of_comments for the post accordingly" do
        query_string = <<-GRAPHQL
            mutation{
                deleteComment(input: {
                commentId: #{@first_comment.id}
                }) {
                successful
                errors
                }
            }
        GRAPHQL

        expect(Comment.all.count).to eq(3)
        expect(@post.number_of_comments).to eq(3)

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(Comment.all.count).to eq(1)
        @post.reload
        expect(@post.number_of_comments).to eq(1)

        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['deleteComment']).to be_a(Hash)
        expect(result['data']['deleteComment']['successful']).to eq(true)
        expect(result['data']['deleteComment']['errors']).to eq([])
    end

    it "should return an error if comment id is not found" do
        query_string = <<-GRAPHQL
            mutation{
                deleteComment(input: {
                commentId: #{@second_comment.id + 1}
                }) {
                successful
                errors
                }
            }
        GRAPHQL

        expect(Comment.all.count).to eq(3)
        expect(@post.number_of_comments).to eq(3)

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(Comment.all.count).to eq(3)
        @post.reload
        expect(@post.number_of_comments).to eq(3)

        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['deleteComment']).to be_a(Hash)
        expect(result['data']['deleteComment']['successful']).to eq(false)
        expect(result['data']['deleteComment']['errors']).to eq(["Comment Id not found"])
    end
end