module Mutations
  class DeleteUser < BaseMutation
    field :message, String, null: true
    field :errors, [String], null: false

    argument :id, Integer, required: true

    def resolve(args)
      user = User.find_by_id(args[:id])

      if user
        user.delete

        { 
          message: "User has been successfully deleted",
          errors: []
        }
      else
        { 
          message: "",
          errors: ["User id not found"]
        }
      end
    end
  end
end
