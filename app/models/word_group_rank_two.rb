class WordGroupRankTwo < ApplicationRecord
  belongs_to :word_group_rank_one

  has_many :word_rank_two_records
  has_many :word_datasets, through: :word_rank_two_records
end
