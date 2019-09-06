class CreateThemeGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :theme_groups do |t|
      t.string :category
    end
  end
end
