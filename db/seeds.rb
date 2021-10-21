# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


user_eternal = User.create!(username: 'Eternal', email: "Eternal@gmail.com", password: '123', password_confirmation: '123', date_of_birth: "05/14/1990")
user_crimson = User.create!(username: 'Crimson', email: "Crimson@gmail.com", password: '123', password_confirmation: '123', date_of_birth: "03/05/1998")
post = Post.create!(user_id: user_eternal.id, message: "First Post")
first_comment = Comment.create!(post_id: post.id, user_id: user_crimson.id, body: "Comments work")
Comment.create!(post_id: post.id, body: "Replies work", user_id: user_eternal.id, parent_id: first_comment.id)