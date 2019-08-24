class SubmodalitiesGroupRankTwo < ApplicationRecord
    #--------------------------------------------------------------------------
    # association
    #--------------------------------------------------------------------------
    # polymorphic association
    include Datable

    # has many association

    # belongs to association
    belongs_to :submodalities_group_rank_one
end
