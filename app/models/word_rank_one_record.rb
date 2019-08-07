class WordRankOneRecord < ApplicationRecord
  belongs_to :word_group_rank_one
  belongs_to :word_dataset
end
