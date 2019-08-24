class PredicateGroupRankOne < ApplicationRecord
    #--------------------------------------------------------------------------
    # assosiations
    #--------------------------------------------------------------------------
    # polymorphic assosiation
    include Datable

    # has many assosiation
    has_many :predicate_group_rank_twos
    #--------------------------------------------------------------------------
    # 
    #--------------------------------------------------------------------------
end
