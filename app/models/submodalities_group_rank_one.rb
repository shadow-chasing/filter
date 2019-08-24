class SubmodalitiesGroupRankOne < ApplicationRecord
  has_many :submodalities_group_rank_twos

  has_many :submodalities_rank_one_records, dependent: :destroy
  has_many :submodalities_datasets, through: :submodalities_rank_one_records
end
