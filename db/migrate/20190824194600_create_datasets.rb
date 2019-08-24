class CreateDatasets < ActiveRecord::Migration[5.2]
  def change
    create_table :datasets do |t|
      t.string :word
      t.references :datable, polymorphic: true
    end
  end
end
