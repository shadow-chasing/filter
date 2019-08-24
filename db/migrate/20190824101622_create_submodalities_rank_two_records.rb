class CreateSubmodalitiesRankTwoRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :submodalities_rank_two_records do |t|
      t.references :submodalities_group_rank_two, index: { name: :index_submod_rank_two_records_on_submod_group_rank_two_id}
      t.references :submodalities_dataset, index: { name: :index_submod_rank_two_records_on_submod_dataset_id}
    end
  end
end
