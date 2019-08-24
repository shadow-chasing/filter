class CreateSubmodalitiesGroupRankTwos < ActiveRecord::Migration[5.2]
  def change
    create_table :submodalities_group_rank_twos do |t|
      t.string :category
      t.references :submodalities_group_rank_one, index: { name: :index_submod_group_rank_two_on_submod_group_rank_one_id}
    end
  end
end
