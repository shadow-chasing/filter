class Dataset < ApplicationRecord
  belongs_to :datable, polymorphic: true
end
