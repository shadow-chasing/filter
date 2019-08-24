class SubmodalitiesGroupRankTwo < ApplicationRecord
  belongs_to :submodalities_group_rank_one

  has_many :submodalities_rank_two_records, dependent: :destroy
  has_many :submodalities_datasets, through: :submodalities_rank_two_records
end
