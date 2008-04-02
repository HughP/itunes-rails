class AddDatabaseIdToTrack < ActiveRecord::Migration
  def self.up
    add_column :tracks, :database_id, :integer
  end

  def self.down
    remove_column :tracks, :database_id
  end
end
