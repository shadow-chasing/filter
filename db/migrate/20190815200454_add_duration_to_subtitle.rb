class AddDurationToSubtitle < ActiveRecord::Migration[5.2]
  def change
    add_column :subtitles, :duration, :integer
  end
end
