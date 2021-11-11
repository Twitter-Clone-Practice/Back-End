module Mutations
  class UnfollowUser < BaseMutation
    description 'Unfollow a user'

    field :successful, Boolean, null: false
    field :errors, [String], null: false

    argument :primary_user_id, Integer, required: true
    argument :user_to_unfollow_id, Integer, required: true

    def resolve(args)
      if (User.exists?(args[:primary_user_id]) && User.exists?(args[:user_to_unfollow_id])) && (args[:primary_user_id] != args[:user_to_unfollow_id])
        follow = Follower.find_by(user_id: args[:user_to_unfollow_id], follower_id: args[:primary_user_id])

        following = Following.find_by(user_id: args[:primary_user_id], following_id: args[:user_to_unfollow_id])

        follow.delete
        following.delete

        {
          successful: true,
          errors: []
        }
      elsif args[:primary_user_id] == args[:user_to_unfollow_id]
      {
        successful: false,
        errors: ["User id's are the same"]
      }
      else
        {
          successful: false,
          errors: ["User not found"]
        }
      end
    end
  end
end
