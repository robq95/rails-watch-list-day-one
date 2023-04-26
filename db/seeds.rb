# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'open-uri'
require 'json'
require 'faker'

puts "Cleaning database..."
List.destroy_all
Movie.destroy_all
Bookmark.destroy_all

puts "Creating lists...."
list = []
10.times do
  list_item = List.create!(name: Faker::Book.unique.genre)
  puts "Adding list # #{list_item.id}"
  puts "List valid? #{list_item.valid?}"
  puts "Errors: #{list_item.errors.messages}"
  list << list_item
  p list
  puts "Bookmark valid? #{list_item.valid?}"
  puts "Errors: #{list_item.errors.messages}"
end

puts "Creating movies...."
url = "https://tmdb.lewagon.com/movie/top_rated?api_key=%3Cyour_api_key%3E"
movies_file = URI.open(url).read
movies = JSON.parse(movies_file)['results']

movies_arr = []
movies.each do |m|
  movie = Movie.create!(
    title: m["original_title"],
    overview: m["overview"],
    poster_url: "https://image.tmdb.org/t/p/original#{m["poster_path"]}",
    rating: m["vote_average"]
  )
  movies_arr << movie
  p movie
  puts "Movie valid? #{movie.valid?}"
  puts "Errors: #{movie.errors.messages}"
end

puts "Creating bookmarks...."
20.times do
  bookmark = Bookmark.new(comment: Faker::Restaurant.unique.review)
  bookmark.movie = movies_arr.sample
  bookmark.list = list.sample
  bookmark.save!
  p bookmark
  puts "Bookmark valid? #{bookmark.valid?}"
  puts "Errors: #{bookmark.errors.messages}"
end
