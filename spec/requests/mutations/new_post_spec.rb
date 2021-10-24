require 'rails_helper'

describe 'New Post' do
  before :each do
    @user_eternal = User.create(
        username: 'EternalFlame',
        email: 'eternal@gmail.com',
        password: '1234',
        password_confirmation: '1234',
        date_of_birth: '05/14/1999'
    )
  end

  it "should create a new post" do
    query_string = <<-GRAPHQL
       mutation {
        newPost(input: {
          userId: #{@user_eternal.id}, 
          message:"cute"
        }) {
        post{
          message
          numberOfLikes
          numberOfComments
        }
        errors
      }
    }
        GRAPHQL
        
    post graphql_path, params: { query: query_string }
    result = JSON.parse(response.body)

    expect(result).to be_a(Hash)
    expect(result['data']).to be_a(Hash)
    expect(result['data']['newPost']['post']).to be_a(Hash)
    expect(result['data']['newPost']['post']['message']).to eq("cute")
    expect(result['data']['newPost']['post']['numberOfLikes']).to eq(0)
    expect(result['data']['newPost']['post']['numberOfComments']).to eq(0)
    expect(result['data']['newPost']['errors']).to eq([])
  end

  it "should return an error if user not found" do
    query_string = <<-GRAPHQL
       mutation {
        newPost(input: {
          userId: #{@user_eternal.id + 1}, 
          message:"cute"
        }) {
        post{
          message
          numberOfLikes
          numberOfComments
        }
        errors
      }
    }
        GRAPHQL
        
    post graphql_path, params: { query: query_string }
    result = JSON.parse(response.body)

    expect(result).to be_a(Hash)
    expect(result['data']).to be_a(Hash)
    expect(result['data']['newPost']['post']).to eq(nil)
    expect(result['data']['newPost']['errors']).to include("User must exist")
  end
end