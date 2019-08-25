class CreateWordRanktwos < ActiveRecord::Migration[5.2]
  def change
    create_table :word_ranktwos do |t|
      t.string :category
      t.integer :word_rankone_id
    end
  end
end
