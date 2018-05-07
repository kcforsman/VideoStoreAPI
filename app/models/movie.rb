class Movie < ApplicationRecord
  validates :title, :release_date, :inventory, presence: true 
end
