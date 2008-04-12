require 'itunes'

describe ITunes do
  before do
    @i = ITunes.new
  end

  it "should find a track by databaseID" do
    pending "tested"
    track = @i.find_track 2673
    track.name.should == "Rehab"
  end

  it "should find a track by string" do
    pending("tested")
    result  = @i.find_track "Rehab"
    result.first.name.should == "Rehab"
  end

  it "should forward calls to the SBApplication object" do
    pending("tested")
    puts "iTunes player state: ", @i.playerState
  end

  it "should insert a track into a playlist" do
    pending("tested")
    track = @i.find_track 2674
    @i.add_track_to_playlist(track, "Test")
  end

  it "should insert a track into Party Shuffle" do
    pending("tested")
    track = @i.find_track 2673
    @i.add_track_to_playlist(track, "Party Shuffle")
  end

  it "should move a track within a playlist" do
    pending "does NOT work"
    track = @i.find_track 2674
    @i.add_track_to_playlist(track, "Test")
    playlist = @i.playlist_by_name("Test")
    playlist.tracks.exchangeObjectAtIndex_withObjectAtIndex(1,2)
  end

  it "should delete a track from a playlist" do
    pending("tested")
    tracks = @i.playlist_by_name("Test").tracks
    puts "Removing #{tracks.last.name}"
    tracks.removeObjectAtIndex(tracks.length - 1)
  end

  it "should create a playlist" do
    pending "tested"
    @i.create_playlist("test playlist")
  end

  it "should create and return the default queue playlist" do
    pending "tested"
    @i.queue.name.should == ITunes::QUEUE_PLAYLIST
  end

  it "should queue a track" do
    pending "tested" 
    track = @i.find_track 2674
    @i.queue_track(track)
  end

  it "should save a track's album artwork to a file" do
    pending "tested"
    @i.create_artwork_for_current_track
  end

  it "should return a list of all the artists in the library" do
    pending "tested"
    @i.artists.class.should == Hash
    @i.artists.each_pair do |k, v|
      puts "#{k} : #{v}"
    end
  end

  it "should return an empty hash for artists if no tracks in playlist" do
    pending "tested"
    playlist = @i.playlist_by_name("name")
    @i.artists(playlist).each_pair do |k, v|
      puts "#{k} : #{v}"
    end
  end

  it "should batch add tracks to the queue efficiently" do
    pending "tested"
    @i.clear_queue
    tracks = @i.playlist_by_name("Purchased").tracks
    tracks.each do |t|
      puts t
      puts t.get.class
      puts t.respond_to?("duplicateTo")
      #@i.add_track_to_playlist(t, "itunes-rails")
    end
    @i.add_tracks_to_playlist(tracks, "itunes-rails")
  end

  it "should batch add tracks to the queue using a Ruby array of tracks" do
    pending "tested"
    @i.clear_queue
    tracks = @i.playlist_by_name("Purchased").tracks.to_a # produce a Ruby array
    tracks.class.should == Array
    @i.add_tracks_to_playlist(tracks, "itunes-rails")
  end

  it "should credit batch add" do
    pending "tested"
    @i.clear_queue
    tracks = @i.playlist_by_name("Purchased").tracks.to_a[0,3] # produce a Ruby array
    @i.add_tracks_to_playlist(tracks, "itunes-rails", "matz")
  end

  it "should reorder the items in the queue" do
    # can just clear the array and rebuild it using passed in tracks params, as
    # if adding
  end

  it "should set the queue playlist as the front window" do 
    pending "tested"
    puts @i.browserWindows.first.view.name
    # call this method:
    @i.select_queue_playlist
    @i.browserWindows.first.view.name.should == ITunes::QUEUE_PLAYLIST
    # @i.queue.duplicateTo(@i.playlistWindows)
  end

  it "should sort the tracks according to a selector" do
    tracks = @i.playlist_by_name("Purchased").tracks
    # unsorted
    puts tracks.map {|t| t.artist.to_s}
    puts "-" * 80

    # false for descending
    descriptor = OSX::NSSortDescriptor.alloc.initWithKey_ascending("artist", true)
    new_tracks = tracks.sortedArrayUsingDescriptors([descriptor])
    # should be sorted
    puts new_tracks.map {|t| t.artist.to_s}

  end
end


