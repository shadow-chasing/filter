class CreateSyntaxes < ActiveRecord::Migration[5.2]
  def change
    create_table :syntaxes do |t|
      t.integer :paragraph
      t.integer :sentence
      t.integer :node
      t.string :word
    end
  end
end
