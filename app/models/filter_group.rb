class FilterGroup < ApplicationRecord
  has_many :filter_group_rank_ones, dependent: :destroy
end
