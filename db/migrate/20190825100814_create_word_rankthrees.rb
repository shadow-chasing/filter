class CreateWordRankthrees < ActiveRecord::Migration[5.2]
  def change
    create_table :word_rankthrees do |t|
      t.string :category
      t.integer :word_ranktwo_id
    end
  end
end
