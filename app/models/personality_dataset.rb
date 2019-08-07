class PersonalityDataset < ApplicationRecord
  belongs_to :personality_group
  #scope :by_country, -> (name) { includes(:addresses).where("addresses.country = ?", "Thailand") }
end
