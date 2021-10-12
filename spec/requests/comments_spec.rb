require 'rails_helper'

describe 'Comments' do
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

    it "can create a new comment" do
        query_string = <<-GRAPHQL
            mutation {
                newComment(input: {
                postId: #{@post.id}
                userId: #{@user_crimson.id}
                reply: "Nice Post"
                }) {
                comment{
                    id
                    reply
                }
                errors
                }
            }
        GRAPHQL

        expect(@post.number_of_replys).to eq(0)

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        @post.reload
        expect(@post.number_of_replys).to eq(1)

        expect(result['data']).to be_a(Hash)
        expect(result['data']["newComment"]).to be_a(Hash)
        expect(result['data']["newComment"]["errors"]).to be_a(Array)
        expect(result['data']["newComment"]["errors"]).to eq([])
        expect(result['data']["newComment"]["comment"]).to be_a(Hash)
        expect(result['data']["newComment"]["comment"]["reply"]).to eq("Nice Post")
    end

    it "Returns an error if user is not found" do
        query_string = <<-GRAPHQL
            mutation {
                newComment(input: {
                postId: #{@post.id}
                userId: #{@user_crimson.id + 1}
                reply: "Nice Post"
                }) {
                comment{
                    id
                    reply
                }
                errors
                }
            }
        GRAPHQL

        expect(@post.number_of_replys).to eq(0)

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        @post.reload
        expect(@post.number_of_replys).to eq(0)

        expect(result['data']).to be_a(Hash)
        expect(result['data']["newComment"]).to be_a(Hash)
        expect(result['data']["newComment"]["errors"]).to be_a(Array)
        expect(result['data']["newComment"]["errors"]).to eq(["User or post not found"])
        expect(result['data']["newComment"]["comment"]).to eq(nil)
    end

    it "Returns an error if the Post is not found" do
        query_string = <<-GRAPHQL
            mutation {
                newComment(input: {
                postId: #{@post.id + 1}
                userId: #{@user_crimson.id}
                reply: "Nice Post"
                }) {
                comment{
                    id
                    reply
                }
                errors
                }
            }
        GRAPHQL

        expect(@post.number_of_replys).to eq(0)

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        @post.reload
        expect(@post.number_of_replys).to eq(0)
        
        expect(result['data']).to be_a(Hash)
        expect(result['data']["newComment"]).to be_a(Hash)
        expect(result['data']["newComment"]["errors"]).to be_a(Array)
        expect(result['data']["newComment"]["errors"]).to eq(["User or post not found"])
        expect(result['data']["newComment"]["comment"]).to eq(nil)
    end

    it "can delete a comment successfully" do
        post_info = PostInfo.create(post_id: @post.id, user_id: @user_crimson.id)
        comment = Comment.create(post_info_id: post_info.id, reply: "Nice Post")

        query_string = <<-GRAPHQL
            mutation {
                deleteComment(input: {
                id: #{comment.id}
                }) {
                success
                errors
                }
            }
        GRAPHQL

        expect(@post.comments.count).to eq(1)
        
        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)
        
        @post.reload
        expect(@post.comments.count).to eq(0)

        expect(result['data']).to be_a(Hash)
        expect(result['data']["deleteComment"]).to be_a(Hash)
        expect(result['data']["deleteComment"]["errors"]).to be_a(Array)
        expect(result['data']["deleteComment"]["errors"]).to eq([])
        expect(result['data']["deleteComment"]["success"]).to eq(true)
    end

    it "Returnes an error if comment id not found to delete" do
        post_info = PostInfo.create(post_id: @post.id, user_id: @user_crimson.id)
        comment = Comment.create(post_info_id: post_info.id, reply: "Nice Post")

        query_string = <<-GRAPHQL
            mutation {
                deleteComment(input: {
                id: #{comment.id + 1}
                }) {
                success
                errors
                }
            }
        GRAPHQL

        expect(@post.comments.count).to eq(1)
        
        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)
        
        @post.reload
        expect(@post.comments.count).to eq(1)

        expect(result['data']).to be_a(Hash)
        expect(result['data']["deleteComment"]).to be_a(Hash)
        expect(result['data']["deleteComment"]["errors"]).to be_a(Array)
        expect(result['data']["deleteComment"]["errors"]).to eq(["Comment not found"])
        expect(result['data']["deleteComment"]["success"]).to eq(false)
    end
end