class CreatePersonalityResults < ActiveRecord::Migration[5.2]
  def change
    create_table :personality_results do |t|
      t.string :rank_one
      t.string :rank_two
      t.string :group
      t.references :subtitle, foreign_key: true
    end
  end
end
