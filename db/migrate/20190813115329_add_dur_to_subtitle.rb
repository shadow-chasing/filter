class AddDurToSubtitle < ActiveRecord::Migration[5.2]
  def change
    add_column :subtitles, :dur, :float
  end
end
