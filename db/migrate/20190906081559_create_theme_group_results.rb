class CreateThemeGroupResults < ActiveRecord::Migration[5.2]
  def change
    create_table :theme_group_results do |t|
      t.string :rankone
      t.string :ranktwo
      t.string :rankthree
      t.references :subtitle, foreign_key: true

      t.timestamps
    end
  end
end
