class WordGroupRankTwo < ApplicationRecord
    #--------------------------------------------------------------------------
    # association
    #--------------------------------------------------------------------------
    # polymorphic association
    include Datable

    # has many association
    has_many :word_group_rank_threes, dependent: :destroy

    # belong to association
    belongs_to :word_group_rank_one
end
