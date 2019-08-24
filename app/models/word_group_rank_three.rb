class WordGroupRankThree < ApplicationRecord
    #--------------------------------------------------------------------------
    # association
    #--------------------------------------------------------------------------
    # polymorphic association
    include Datable

    # has many association

    # belongs to association
    belongs_to :word_group_rank_two
end
