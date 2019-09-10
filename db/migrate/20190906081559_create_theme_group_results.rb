class CreateThemeGroupResults < ActiveRecord::Migration[5.2]
  def change
    create_table :theme_group_results do |t|
      t.string :rank_one
      t.string :rank_two
      t.string :rank_three
      t.string :group
      t.references :subtitle, foreign_key: true
    end
  end
end
