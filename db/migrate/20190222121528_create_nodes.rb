class CreateNodes < ActiveRecord::Migration[5.2]
  def change
    create_table :nodes do |t|
      t.integer :node
      t.references :sentence, foreign_key: true
    end
  end
end
