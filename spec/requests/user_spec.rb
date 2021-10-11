require 'rails_helper'

describe 'Create User Mutation' do
    before :each do
        @user_eternal = User.create(
            username: 'EternalFlame',
            email: 'eternal@gmail.com',
            password: '1234',
            password_confirmation: '1234',
            date_of_birth: '05/14/1999'
        )
    end

    it "Can create a new user" do
        query_string = <<-GRAPHQL
            mutation {
                createUser(input: {
                    username: "CrimsoneGhost",
                    email: "crimson@gmail.com",
                    password: "1234",
                    passwordConfirmation: "1234",
                    dateOfBirth: "01/05/1998"
                }) {
                    user {
                        username
                        email
                        dateOfBirth
                    }
                    errors
                }
            }
        GRAPHQL

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['createUser']).to be_a(Hash)
        expect(result['data']['createUser']['user']).to be_a(Hash)
        expect(result['data']['createUser']['errors']).to be_a(Array)

        expect(result['data']['createUser']['user']['username']).to eq('CrimsoneGhost')
        expect(result['data']['createUser']['user']['email']).to eq('crimson@gmail.com')
        expect(result['data']['createUser']['user']['dateOfBirth']).to eq('01/05/1998')
        expect(result['data']['createUser']['errors']).to eq([])
    end

    it 'Should give error if username already exists' do
        query_string = <<-GRAPHQL
            mutation {
                createUser(input: {
                    username: "EternalFlame",
                    email: "test@gmail.com",
                    password: "1234",
                    passwordConfirmation: "1234",
                    dateOfBirth: "01/05/1998"
                }) {
                    user {
                        username
                        email
                        dateOfBirth
                    }
                    errors
                }
            }
        GRAPHQL

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['createUser']).to be_a(Hash)
        expect(result['data']['createUser']['user']).to eq(nil)
        expect(result['data']['createUser']['errors']).to be_a(Array)

        expect(result['data']['createUser']['errors']).to eq(["Username has already been taken"])
    end

    it 'Should give error if email already exists' do
        query_string = <<-GRAPHQL
            mutation {
                createUser(input: {
                    username: "TestAccount",
                    email: "eternal@gmail.com",
                    password: "1234",
                    passwordConfirmation: "1234",
                    dateOfBirth: "01/05/1998"
                }) {
                    user {
                        username
                        email
                        dateOfBirth
                    }
                    errors
                }
            }
        GRAPHQL

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['createUser']).to be_a(Hash)
        expect(result['data']['createUser']['user']).to eq(nil)
        expect(result['data']['createUser']['errors']).to be_a(Array)

        expect(result['data']['createUser']['errors']).to eq(["Email has already been taken"])
    end

    it 'Should give error if the password and password confirmation dont match' do
        query_string = <<-GRAPHQL
            mutation {
                createUser(input: {
                    username: "CrimsoneGhost",
                    email: "crimson@gmail.com",
                    password: "1234",
                    passwordConfirmation: "1235",
                    dateOfBirth: "01/05/1998"
                }) {
                    user {
                        username
                        email
                        dateOfBirth
                    }
                    errors
                }
            }
        GRAPHQL

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['createUser']).to be_a(Hash)
        expect(result['data']['createUser']['user']).to eq(nil)
        expect(result['data']['createUser']['errors']).to be_a(Array)

        expect(result['data']['createUser']['errors']).to eq(["Password confirmation doesn't match Password"])
    end

    it 'Should be able to give multiple errors' do
        query_string = <<-GRAPHQL
            mutation {
                createUser(input: {
                    username: "EternalFlame",
                    email: "eternal@gmail.com",
                    password: "1234",
                    passwordConfirmation: "1234",
                    dateOfBirth: "01/05/1998"
                }) {
                    user {
                        username
                        email
                        dateOfBirth
                    }
                    errors
                }
            }
        GRAPHQL

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['createUser']).to be_a(Hash)
        expect(result['data']['createUser']['user']).to eq(nil)
        expect(result['data']['createUser']['errors']).to be_a(Array)

        expect(result['data']['createUser']['errors'].length).to eq(2)
        expect(result['data']['createUser']['errors']).to include("Username has already been taken")
        expect(result['data']['createUser']['errors']).to include("Email has already been taken")
    end

    it "should be able to delete a user" do
        query_string = <<-GRAPHQL
            mutation {
                deleteUser(input: {
                    id: #{@user_eternal.id}
                }) {
                    message
                    errors
                }
            }
        GRAPHQL

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['deleteUser']).to be_a(Hash)
        expect(result['data']['deleteUser']['message']).to eq("User has been successfully deleted")
        expect(result['data']['deleteUser']['errors']).to be_a(Array)
        expect(result['data']['deleteUser']['errors']).to eq([])
    end

    it "should return error if id is not found when deleting a user" do
        query_string = <<-GRAPHQL
            mutation {
                deleteUser(input: {
                    id: #{@user_eternal.id + 1}
                }) {
                    message
                    errors
                }
            }
        GRAPHQL

        post graphql_path, params: { query: query_string }
        result = JSON.parse(response.body)

        expect(result).to be_a(Hash)
        expect(result['data']).to be_a(Hash)
        expect(result['data']['deleteUser']).to be_a(Hash)
        expect(result['data']['deleteUser']['message']).to eq("")
        expect(result['data']['deleteUser']['errors']).to be_a(Array)
        expect(result['data']['deleteUser']['errors']).to include("User id not found")
    end
end