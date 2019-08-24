class WordGroupRankOne < ApplicationRecord
    #--------------------------------------------------------------------------
    # association
    #--------------------------------------------------------------------------
    # polymorphic association
    include Datable

    # has many association
    has_many :word_group_rank_twos

    # belongs to association
end
