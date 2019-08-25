class CreateWordRankones < ActiveRecord::Migration[5.2]
  def change
    create_table :word_rankones do |t|
      t.string :category
    end
  end
end
