class CreateWordGroupResults < ActiveRecord::Migration[5.2]
  def change
    create_table :word_group_results do |t|
      t.string :rank_one
      t.string :rank_two
      t.string :rank_three
      t.string :group
      t.string :predicate
      t.references :subtitle, foreign_key: true

    end
  end
end
