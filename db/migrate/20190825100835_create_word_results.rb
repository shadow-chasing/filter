class CreateWordResults < ActiveRecord::Migration[5.2]
  def change
    create_table :word_results do |t|
      t.string :rankone
      t.string :ranktwo
      t.string :rankthree
      t.references :subtitle, foreign_key: true
    end
  end
end
