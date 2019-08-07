class FilterGroupRankTwo < ApplicationRecord
  belongs_to :filter_group_rank_one

  has_many :filter_rank_two_records
  has_many :filter_datasets, through: :filter_rank_two_records
end
