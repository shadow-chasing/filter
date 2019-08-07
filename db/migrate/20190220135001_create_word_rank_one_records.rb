class CreateWordRankOneRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :word_rank_one_records do |t|
      t.references :word_group_rank_one, foreign_key: true
      t.references :word_dataset, foreign_key: true
    end
  end
end
