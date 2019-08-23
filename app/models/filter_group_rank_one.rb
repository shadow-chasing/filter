class FilterGroupRankOne < ApplicationRecord
  has_many :filter_group_rank_twos

  has_many :filter_rank_one_records, dependent: :destroy
  has_many :filter_datasets, through: :filter_rank_one_records
end
