# Wrap an iTunesTrack into a json representation
module Json
  class ITunesTrack 

    attr_accessor :itunes_track
    def initialize(itunes_track)
      @itunes_track = itunes_track
    end

    def to_hash
      # Must call the to_s methods on every property
      hash = { 
        :databaseID => self.databaseID.to_i,
        # will be a string or null after conversion to JSON
        :artwork_file => ITUNES.artwork_file(@itunes_track)
      }

      [:playedCount, :rating, :year].each do |x|
        hash[x] = self.send(x).to_s
      end 

      [:databaseID, :artist, :name, :album, :genre, :comment, :category, :time].each do |y|
        hash[y] = self.send(y).to_s
      end

      [:dateAdded, :playedDate].each do |z|
        hash[z] = self.send(z) && self.send(z).description.to_s
      end
      hash
    end

    def method_missing(name, *args)
      @itunes_track.send(name, *args)
    end

    def to_s
      to_json
    end
  end
end
