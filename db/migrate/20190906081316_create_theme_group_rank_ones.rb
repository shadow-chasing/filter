class CreateThemeGroupRankOnes < ActiveRecord::Migration[5.2]
  def change
    create_table :theme_group_rank_ones do |t|
      t.string :category

      t.timestamps
    end
  end
end
