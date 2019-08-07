class Node < ApplicationRecord
  belongs_to :sentence
  has_many :words
end
