class PredicateDataset < ApplicationRecord

  has_many :predicate_rank_one_records, dependent: :destroy
  has_many :predicate_group_rank_ones, through: :predicate_rank_one_records

end
