class Trackinglist < ApplicationRecord
  has_many :racket
  serialize :racket_id,Array
end
