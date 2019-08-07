class CreateFilterGroupRankTwos < ActiveRecord::Migration[5.2]
  def change
    create_table :filter_group_rank_twos do |t|
      t.string :category
      t.references :filter_group_rank_one, foreign_key: true
    end
  end
end
