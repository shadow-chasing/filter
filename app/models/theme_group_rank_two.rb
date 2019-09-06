class ThemeGroupRankTwo < ApplicationRecord
    #--------------------------------------------------------------------------
    # association
    #--------------------------------------------------------------------------
    # polymorphic association
    include Datable

    # has many association

    # belongs to association
    belongs_to :theme_group_rank_one
end
