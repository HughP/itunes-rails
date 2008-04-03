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
    @i.create_artwork_for_current_track
  end
end

