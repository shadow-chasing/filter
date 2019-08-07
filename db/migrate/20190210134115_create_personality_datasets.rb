class CreatePersonalityDatasets < ActiveRecord::Migration[5.2]
  def change
    create_table :personality_datasets do |t|
      t.string :word
      t.references :personality_group, foreign_key: true
    end
  end
end
