class CreateListings < ActiveRecord::Migration
  def self.up
    create_table :listings do |t|
      t.integer :track_id
      t.integer :playlist_id
      t.string :name
      t.integer :index # position in playlist
      t.datetime :updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :listings
  end
end
