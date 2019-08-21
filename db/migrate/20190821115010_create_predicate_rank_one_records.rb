class CreatePredicateRankOneRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :predicate_rank_one_records do |t|
      t.references :predicate_group_rank_one, foreign_key: true
      t.references :predicate_dataset, foreign_key: true
    end
  end
end
