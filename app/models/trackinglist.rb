class Trackinglist < ApplicationRecord
  has_many :rocket
  serialize :rocket_id,Array
end
