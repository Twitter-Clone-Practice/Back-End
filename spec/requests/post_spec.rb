require 'rails_helper'

describe 'Post' do
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
          numberOfReplys
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
    expect(result['data']['newPost']['post']['numberOfReplys']).to eq(0)
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
          numberOfReplys
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

  it "should be able to delete a post" do
    post = Post.create(
      user_id: @user_eternal.id,
      message: "cool"
    )

    query_string = <<-GRAPHQL
      mutation {
        deletePost(input: {
          id: #{post.id}
        }) {
          success
          errors
        }
      }
    GRAPHQL

    expect(Post.all.count).to eq(1)
        
    post graphql_path, params: { query: query_string }
    result = JSON.parse(response.body)

    
    expect(Post.all.count).to eq(0)

    expect(result).to be_a(Hash)
    expect(result['data']).to be_a(Hash)
    expect(result['data']["deletePost"]).to be_a(Hash)
    expect(result['data']["deletePost"]["success"]).to eq(true)
    expect(result['data']["deletePost"]["errors"]).to be_a(Array)
    expect(result['data']["deletePost"]["errors"]).to eq([])
  end

  it "should return an error if post of is not found to delete" do
    post = Post.create(
      user_id: @user_eternal.id,
      message: "cool"
    )

    query_string = <<-GRAPHQL
      mutation {
        deletePost(input: {
          id: #{post.id + 1}
        }) {
          success
          errors
        }
      }
    GRAPHQL

    expect(Post.all.count).to eq(1)
        
    post graphql_path, params: { query: query_string }
    result = JSON.parse(response.body)

    
    expect(Post.all.count).to eq(1)

    expect(result).to be_a(Hash)
    expect(result['data']).to be_a(Hash)
    expect(result['data']["deletePost"]).to be_a(Hash)
    expect(result['data']["deletePost"]["success"]).to eq(false)
    expect(result['data']["deletePost"]["errors"]).to be_a(Array)
    expect(result['data']["deletePost"]["errors"]).to eq(["post Id not found"])
  end
end