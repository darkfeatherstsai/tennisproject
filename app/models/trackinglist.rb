class Trackinglist < ApplicationRecord
  belongs_to :user
  serialize :racket_id,Array
end
