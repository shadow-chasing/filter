class CreateFilterGroupRankOnes < ActiveRecord::Migration[5.2]
  def change
    create_table :filter_group_rank_ones do |t|
      t.string :category
      t.references :filter_group, foreign_key: true
    end
  end
end
