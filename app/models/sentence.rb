class Sentence < ApplicationRecord
  belongs_to :paragraph
  has_many :nodes
end
