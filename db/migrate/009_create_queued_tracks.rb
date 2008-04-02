class CreateQueuedTracks < ActiveRecord::Migration
  def self.up
    create_table :queued_tracks do |t|
      t.integer :track_id
      t.string :queued_by
      t.integer :listing_id
      t.datetime :created_at

      t.timestamps
    end
  end

  def self.down
    drop_table :queued_tracks
  end
end
