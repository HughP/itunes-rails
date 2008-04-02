class AddPositionToQt < ActiveRecord::Migration
  def self.up
    add_column :queued_tracks, :position, :integer
  end

  def self.down
    remove_column :queued_tracks, :position
  end
end
