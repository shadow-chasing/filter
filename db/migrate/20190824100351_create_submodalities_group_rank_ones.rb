class CreateSubmodalitiesGroupRankOnes < ActiveRecord::Migration[5.2]
  def change
    create_table :submodalities_group_rank_ones do |t|
      t.string :category
    end
  end
end
