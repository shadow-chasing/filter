class CreatePredicateGroupRankOnes < ActiveRecord::Migration[5.2]
  def change
    create_table :predicate_group_rank_ones do |t|
      t.string :category
      t.references :predicate_group, foreign_key: true
    end
  end
end
