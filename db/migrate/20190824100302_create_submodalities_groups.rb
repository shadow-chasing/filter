class CreateSubmodalitiesGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :submodalities_groups do |t|
      t.string :category
    end
  end
end
