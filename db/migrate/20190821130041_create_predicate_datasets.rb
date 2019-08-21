class CreatePredicateDatasets < ActiveRecord::Migration[5.2]
  def change
    create_table :predicate_datasets do |t|
      t.string :word

      t.timestamps
    end
  end
end
