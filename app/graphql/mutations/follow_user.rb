module Mutations
  class FollowUser < BaseMutation
    field :success, Boolean, null: false
    field :errors, [String], null: false

    argument :primary_user_id, Integer, required: true
    argument :user_to_follow_id, Integer, required: true

    def resolve(args)
      new_follow = Following.new(
        user_id: args[:primary_user_id],
        following_id: args[:user_to_follow_id]
      )

      new_follower = Follower.new(
        user_id: args[:user_to_follow_id],
        follower_id: args[:primary_user_id]
      )

      if new_follow.save && new_follower.save
        {
          success: true,
          errors: []
        }
      else
        {
          Success: false,
          errors: ["User not found"]
        }
      end
    end
  end
end
