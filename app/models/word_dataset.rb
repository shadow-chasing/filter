class WordDataset < ApplicationRecord
  has_many :word_rank_one_records
  has_many :word_group_rank_ones, through: :word_rank_one_records

  has_many :word_rank_two_records
  has_many :word_group_rank_twos, through: :word_rank_two_records

  has_many :word_rank_three_records, dependent: :destroy
  has_many :word_group_rank_threes, through: :word_rank_three_records
end
