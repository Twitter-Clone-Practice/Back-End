# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user_eternal = User.create(username: 'Eternal', email: "Eternal@gmail.com", password: '123', password_confirmation: '123', date_of_birth: "05/14/1990")
User.create(username: 'Crimson', email: "Crimson@gmail.com", password: '123', password_confirmation: '123', date_of_birth: "03/05/1998")
Post.create(user_id: user_eternal.id, message: "cool")