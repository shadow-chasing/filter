class CreateWordGroupRankThrees < ActiveRecord::Migration[5.2]
  def change
    create_table :word_group_rank_threes do |t|
      t.string :category
      t.references :word_group_rank_two, foreign_key: true
    end
  end
end
