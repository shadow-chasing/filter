class FilterGroupRankOne < ApplicationRecord
  belongs_to :filter_group
  has_many :filter_group_rank_twos

  has_many :filter_rank_one_records
  has_many :filter_datasets, through: :filter_rank_one_records
end
