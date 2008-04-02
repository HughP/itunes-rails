class AlterQueuedT < ActiveRecord::Migration
  def self.up
    remove_column :queued_tracks, :listing_id
    add_column :queued_tracks, :playlist_id, :integer
  end

  def self.down
    remove_column :queued_tracks, :playlist_id
    add_column :queued_tracks, :listing_id, :integer
  end
end
