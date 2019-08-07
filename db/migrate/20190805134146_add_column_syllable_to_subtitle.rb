class AddColumnSyllableToSubtitle < ActiveRecord::Migration[5.2]
  def change
    add_column :subtitles, :syllable, :integer, default: 0
  end
end
