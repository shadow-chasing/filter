class SubmodalitiesGroupRankOne < ApplicationRecord
    #--------------------------------------------------------------------------
    # association
    #--------------------------------------------------------------------------
    # polymorphic association
    include Datable

    # has many association

    # belongs to association
    has_many :submodalities_group_rank_twos
end
