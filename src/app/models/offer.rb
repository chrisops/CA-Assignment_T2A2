class Offer < ApplicationRecord
  belongs_to :buyer, class_name: :user
  belongs_to :seller
  belongs_to :card
end
