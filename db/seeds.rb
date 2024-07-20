# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "seedの実行を開始"

admin = Admin.find_or_create_by!(email: "admin@test.com") do |admin|
  admin.password = "adminpassword"
end

guestadmin = Admin.find_or_create_by!(id: 2) do |admin|
  admin.email = "admin_guest@example.com"
  admin.password = "guestpassword"
end

apple = User.find_or_create_by!(email: "apple@example.com") do |user|
  user.name = "apple"
  user.password = "password"
end

bee = User.find_or_create_by!(email: "bee@example.com") do |user|
  user.name = "bee"
  user.password = "password"
end

Post.find_or_create_by!(body: "あかいトマトはとってもおいしそうです。") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post1.jpg"), filename:"sample-post1.jpg")
  post.color = "red"
  post.is_open = "true"
  post.user = apple
end

Post.find_or_create_by!(body: "きいろいパインは常夏を感じます。") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post2.png"), filename:"sample-post2.png")
  post.color = "yellow"
  post.is_open = "true"
  post.user = bee
end

puts "seedの実行が完了しました"