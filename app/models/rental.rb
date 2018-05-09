class Rental < ApplicationRecord
  belongs_to :movie
  belongs_to :customer

  validates :checkout_date, :due_date, presence: true
  validates_inclusion_of :returned, in: [true, false]
end
