# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


#Users
user_eternal = User.create!(username: 'Eternal', email: "Eternal@gmail.com", password: '123', password_confirmation: '123', date_of_birth: "05/14/1990")
user_crimson = User.create!(username: 'Crimson', email: "Crimson@gmail.com", password: '123', password_confirmation: '123', date_of_birth: "03/05/1998")

#follows
Following.create!(
  user_id: user_eternal.id,
  following_id: user_crimson.id
)
Follower.create!(
  user_id: user_crimson.id,
  follower_id: user_eternal.id
)

#Posts
post = Post.create!(user_id: user_eternal.id, message: "First Post", number_of_comments: 2, number_of_likes: 1)
second_post = Post.create!(user_id: user_eternal.id, message: "Second Post", number_of_comments: 2, number_of_likes: 1)
crimson_post = Post.create!(user_id: user_crimson.id, message: "Cool", number_of_comments: 0, number_of_likes: 1)

#Comments
first_comment = Comment.create!(post_id: post.id, user_id: user_crimson.id, body: "Comments work")
Comment.create!(post_id: post.id, body: "Replies work", user_id: user_eternal.id, parent_id: first_comment.id)

#Likes
Like.create!(post_id: post.id, user_id: user_crimson.id)
Like.create!(post_id: second_post.id, user_id: user_crimson.id)
Like.create!(post_id: crimson_post.id, user_id: user_eternal.id)
