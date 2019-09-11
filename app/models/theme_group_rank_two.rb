class ThemeGroupRankTwo < ApplicationRecord
    #--------------------------------------------------------------------------
    # association
    #--------------------------------------------------------------------------
    # polymorphic association
    include Datable

    # has many association
    has_many :theme_group_rank_threes

    # belongs to association
    belongs_to :theme_group_rank_one

end
