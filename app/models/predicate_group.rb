class PredicateGroup < ApplicationRecord
  has_many :predicate_group_rank_ones, dependent: :destroy
end
