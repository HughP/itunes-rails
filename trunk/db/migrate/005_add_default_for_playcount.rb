class AddDefaultForPlaycount < ActiveRecord::Migration
  def self.up
    change_column :tracks, :play_count, :integer, :default => 0
  end

  def self.down
    change_column :tracks, :play_count
  end
end
