class Mutation::CreateUser < BaseMutation
  # description "this will create new users"

  argument :username, String, required: true 
  argument :email, String, required: true 
  argument :password, String, required: true 
  argument :password_digest, String, required: true 
  argument :date_of_birth, String, required: true 

  field :user, Types::UserType, null: false
  field :errors, [String], null: false

  def resolve(username:, email:, password:, password_digest:, date_of_birth:)
    user = User.new(username: username, 
                    email: email,
                    password: password,
                    password_digest: password_digest,
                    date_of_birth: date_of_birth
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