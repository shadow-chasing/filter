class WordGroupRankOne < ApplicationRecord
  belongs_to :word_group
  has_many :word_group_rank_twos

  has_many :word_rank_one_records, dependent: :destroy
  has_many :word_datasets, through: :word_rank_one_records
end
