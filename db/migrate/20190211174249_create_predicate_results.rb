class CreatePredicateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :predicate_results do |t|
      t.string :rank_one
      t.string :rank_two
      t.string :group
      t.string :predicate
      t.references :subtitle, foreign_key: true
    end
  end
end
