require 'rails_helper'

describe 'Fetch Post' do
    before :each do
        @user_eternal = User.create(
            username: 'EternalFlame',
            email: 'eternal@gmail.com',
            password: '1234',
            password_confirmation: '1234',
            date_of_birth: '05/14/1999'
        )

        @post = Post.create!(user_id: @user_eternal.id, message: "First Post")
    end

    it "Shoild be able to return a specific post" do
        query_string = <<-GRAPHQL
            query{
                fetchPost(postId: #{@post.id}){
                    id
                    userId
                    message
                    numberOfLikes
                    numberOfComments
                    comments {
                        id
                    }
                }
            }
        GRAPHQL

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)
        
        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['fetchPost']).to be_a(Hash)
        expect(result['data']['fetchPost']['userId']).to eq(@user_eternal.id)
        expect(result['data']['fetchPost']['message']).to eq(@post.message)
        expect(result['data']['fetchPost']['numberOfLikes']).to eq(@post.number_of_likes)
        expect(result['data']['fetchPost']['numberOfComments']).to eq(@post.number_of_comments)
        expect(result['data']['fetchPost']['comments']).to eq(@post.comments)
    end
end