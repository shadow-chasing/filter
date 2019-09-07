class ThemeGroupRankOne < ApplicationRecord
    #--------------------------------------------------------------------------
    # association
    #--------------------------------------------------------------------------
    # polymorphic association
    include Datable

    # has many association
    has_many :theme_group_rank_twos

    # belongs to association
end
