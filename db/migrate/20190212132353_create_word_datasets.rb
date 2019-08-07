class CreateWordDatasets < ActiveRecord::Migration[5.2]
  def change
    create_table :word_datasets do |t|
      t.string :word
    end
  end
end
