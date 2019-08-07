class CreateParagraphs < ActiveRecord::Migration[5.2]
  def change
    create_table :paragraphs do |t|
      t.integer :paragraph
      t.string :title
    end
  end
end
