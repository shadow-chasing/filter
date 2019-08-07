class CreateFilterRankTwoRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :filter_rank_two_records do |t|
      t.references :filter_group_rank_two, foreign_key: true
      t.references :filter_dataset, foreign_key: true
    end
  end
end
