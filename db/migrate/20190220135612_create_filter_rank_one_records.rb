class CreateFilterRankOneRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :filter_rank_one_records do |t|
      t.references :filter_group_rank_one, foreign_key: true
      t.references :filter_dataset, foreign_key: true
    end
  end
end
