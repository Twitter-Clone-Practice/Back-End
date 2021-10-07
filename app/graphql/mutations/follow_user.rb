module Mutations
  class FollowUser < BaseMutation
    field :success, Boolean, null: false
    field :errors, [String], null: false

    argument :primary_user_id, Integer, required: true
    argument :user_to_follow_id, Integer, required: true

    def resolve(args)
      primary_user = User.find_by(id: args[:primary_user_id])
      secondary_user = User.find_by(id: args[:user_to_follow_id])
      if primary_user && secondary_user
        new_follow = Following.new(
          user_id: args[:primary_user_id],
          following_id: args[:user_to_follow_id]
        )
        
        new_follower = Follower.new(
          user_id: args[:user_to_follow_id],
          follower_id: args[:primary_user_id]
        )

        if new_follow.save
          if new_follower.save
            {
              success: true,
              errors: []
            }
          else
            new_follow.delete
            {
              Success: false,
              errors: new_follower.errors.full_messages
            }
          end
        else
          {
            Success: false,
            errors: new_follow.errors.full_messages
          }
        end
      else
        {
          Success: false,
          errors: ["User does not exist!"]
        }
      end
    end
  end
end