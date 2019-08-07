class CreatePredicateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :predicate_groups do |t|
      t.string :category
    end
  end
end
