class CreateSubtitles < ActiveRecord::Migration[5.2]
  def change
    create_table :subtitles do |t|
      t.string :word
      t.string :title
      t.integer :syllable
      t.integer :length, default: 0
      t.integer :counter
      t.integer :duration
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
