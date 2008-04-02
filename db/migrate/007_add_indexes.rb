class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :listings, :track_id
  end

  def self.down
    remove_index :listings, :column => :track_id
  end
end
