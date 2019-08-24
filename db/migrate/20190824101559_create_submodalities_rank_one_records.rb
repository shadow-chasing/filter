class CreateSubmodalitiesRankOneRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :submodalities_rank_one_records do |t|
      t.references :submodalities_group_rank_one, index: { name: :index_submod_rank_one_records_on_submod_group_rank_one_id}
      t.references :submodalities_dataset, index: { name: :index_submod_rank_one_records_on_submod_dataset_id}
    end
  end
end
