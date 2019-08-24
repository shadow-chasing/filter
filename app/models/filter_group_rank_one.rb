class FilterGroupRankOne < ApplicationRecord
    #--------------------------------------------------------------------------
    # assosiations
    #--------------------------------------------------------------------------
    # polymorphic assosiation
    include Datable

    # has many assosiation
    has_many :filter_group_rank_twos
    #--------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------
end
