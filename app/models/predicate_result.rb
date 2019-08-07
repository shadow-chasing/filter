class PredicateResult < ApplicationRecord

  # before_save :update_published_at
  #
  # def update_unpublished_at
  #   self.published_at = nil if published == false
  # end


  belongs_to :subtitle

  # for counting predicate column result.
  def self.group_filter(name)
    where(group: "predicate").where(rank_one: name)
  end

end
