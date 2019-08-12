class PersonalityGroup < ApplicationRecord
  has_many :personality_datasets, dependent: :destroy
end
