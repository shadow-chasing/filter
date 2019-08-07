class CreateWordGroupRankOnes < ActiveRecord::Migration[5.2]
  def change
    create_table :word_group_rank_ones do |t|
      t.string :category
      t.references :word_group, foreign_key: true
    end
  end
end
