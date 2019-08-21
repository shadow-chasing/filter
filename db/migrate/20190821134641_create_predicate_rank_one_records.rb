class CreatePredicateRankOneRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :predicate_rank_one_records do |t|
      t.references :predicate_group_rank_one, index: { name: :index_pre_rank_one_records_on_predicate_group_rank_one_id}
      t.references :predicate_dataset, foreign_key: true
    end
  end
end
