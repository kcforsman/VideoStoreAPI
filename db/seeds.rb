JSON.parse(File.read('db/seeds/customers.json')).each do |customer|
  Customer.create!(customer)
end

JSON.parse(File.read('db/seeds/movies.json')).each do |movie|
  new_movie = Movie.create!(movie)
  new_movie.available_inventory = movie["inventory"]
  new_movie.save!
end
