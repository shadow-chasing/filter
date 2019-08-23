class CreateWordRankThreeRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :word_rank_three_records do |t|
      t.references :word_dataset, foreign_key: true
      t.references :word_group_rank_three, foreign_key: true

      t.timestamps
    end
  end
end
