class CreateThemeRankThrees < ActiveRecord::Migration[5.2]
  def change
    create_table :theme_rank_threes do |t|
      t.string :category
      t.references :theme_rank_two, foreign_key: true
    end
  end
end
