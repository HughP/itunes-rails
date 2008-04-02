class CreatePlayedTracks < ActiveRecord::Migration
  def self.up
    create_table :played_tracks do |t|
      t.integer :track_id
      t.string :queued_by 
      t.datetime :created_at  # marks time playing started at 
      t.integer :playlist_id 

      t.timestamps
    end
  end

  def self.down
    drop_table :played_tracks
  end
end
