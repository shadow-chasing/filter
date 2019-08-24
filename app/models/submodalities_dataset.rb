class SubmodalitiesDataset < ApplicationRecord
  has_many :submodalities_rank_one_records, dependent: :destroy
  has_many :submodalities_group_rank_ones, through: :submodalities_rank_one_records

  has_many :submodalities_rank_two_records, dependent: :destroy
  has_many :submodalities_group_rank_twos, through: :submodalities_rank_two_records
end
