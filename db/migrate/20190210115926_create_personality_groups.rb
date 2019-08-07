class CreatePersonalityGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :personality_groups do |t|
      t.string :category
    end
  end
end
