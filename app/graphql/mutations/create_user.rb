module Mutations
  class CreateUser < BaseMutation

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    argument :username, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true
    argument :email, String, required: true
    argument :date_of_birth, String, required: true

    def resolve(args)
      user = User.new(
        username: args[:username],
        password: args[:password],
        password_confirmation: args[:password_confirmation],
        email: args[:email],
        date_of_birth: args[:date_of_birth]
      )

      if user.save
        { 
          user: user,
          errors: []
        }
      else
        {
          user: nil,
          errors: user.errors.full_messages
        }
      end
    end
  end
end
