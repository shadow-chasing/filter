class CreateSubmodalitiesDatasets < ActiveRecord::Migration[5.2]
  def change
    create_table :submodalities_datasets do |t|
      t.string :word

      t.timestamps
    end
  end
end
