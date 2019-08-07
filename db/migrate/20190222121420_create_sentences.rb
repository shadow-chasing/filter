class CreateSentences < ActiveRecord::Migration[5.2]
  def change
    create_table :sentences do |t|
      t.integer :sentence
      t.references :paragraph, foreign_key: true
    end
  end
end
