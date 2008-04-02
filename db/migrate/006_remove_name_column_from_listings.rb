class RemoveNameColumnFromListings < ActiveRecord::Migration
  def self.up
    remove_column :listings, :name
  end

  def self.down
    add_column :listings, :name, :string
  end
end
