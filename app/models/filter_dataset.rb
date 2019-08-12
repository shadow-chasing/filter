class FilterDataset < ApplicationRecord
  has_many :filter_rank_one_records, dependent: :destroy
  has_many :filter_group_rank_ones, through: :filter_rank_one_records

  has_many :filter_rank_two_records, dependent: :destroy
  has_many :filter_group_rank_twos, through: :filter_rank_two_records
end
