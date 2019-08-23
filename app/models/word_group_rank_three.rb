class WordGroupRankThree < ApplicationRecord
  belongs_to :word_group_rank_two

  has_many :word_rank_three_records, dependent: :destroy
  has_many :word_datasets, through: :word_rank_three_records

end
