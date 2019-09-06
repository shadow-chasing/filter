class CreateThemeRankOnes < ActiveRecord::Migration[5.2]
  def change
    create_table :theme_rank_ones do |t|
      t.string :category
    end
  end
end
