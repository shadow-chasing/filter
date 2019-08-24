class FilterGroupRankTwo < ApplicationRecord
    #--------------------------------------------------------------------------
    # assosiations
    #--------------------------------------------------------------------------
    # polymorphic assosiation
    include Datable

    # belongs to assosiation
    belongs_to :filter_group_rank_one
    #--------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------
end
