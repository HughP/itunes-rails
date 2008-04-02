class CreatePlaylists < ActiveRecord::Migration
  def self.up
    create_table :playlists do |t|
      t.string :name
      t.integer :index # position in source 0 (Library)

      t.timestamps
    end
  end

  def self.down
    drop_table :playlists
  end
end
