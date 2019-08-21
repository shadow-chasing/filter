class PredicateGroupRankOne < ApplicationRecord

  has_many :predicate_rank_one_records, dependent: :destroy
  has_many :predicate_datasets, through: :predicate_rank_one_records

end
