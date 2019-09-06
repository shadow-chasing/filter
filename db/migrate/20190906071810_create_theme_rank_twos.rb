class CreateThemeRankTwos < ActiveRecord::Migration[5.2]
  def change
    create_table :theme_rank_twos do |t|
      t.string :category
      t.references :theme_rank_one, foreign_key: true
    end
  end
end
