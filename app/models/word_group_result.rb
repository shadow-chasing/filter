class WordGroupResult < ApplicationRecord
  belongs_to :subtitle

  scope :high, -> { where("LENGTH(length) > 3") }

end
