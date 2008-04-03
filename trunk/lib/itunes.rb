require 'osx/cocoa'
OSX.require_framework 'ScriptingBridge'

class ITunes
  QUEUE_PLAYLIST = 'itunes-rails'
  def initialize
    @app = OSX::SBApplication.applicationWithBundleIdentifier("com.apple.iTunes")
  end

  # Delegate all other methods to the SBAppliation object for iTunes
  def method_missing(message, *args)
    @app.send(message, *args)
  end

  def party_shuffle
    playlists.detect {|x| x.name == "Party Shuffle"}
  end

  def playlists
    @app.sources.first.playlists
  end

  def playlist_by_name(name)
    playlists.detect {|p| p.name == name}
  end

  def library
    playlists.first
  end

  # Pass in a string to get matching tracks. Pass in an integer to search by 
  # databaseID
  def find_track(query)
    if query.is_a?(String)
      library.searchFor_only(query, nil)
    elsif query.is_a?(Integer) # lookup by databaseID
      predicate = OSX::NSPredicate.predicateWithFormat("databaseID == #{query}")
      # assume that only one track matches, and return it
      library.tracks.filteredArrayUsingPredicate(predicate).first
    end
  end

  def add_track_to_playlist(track, playlist)
    if playlist.is_a?(String)
      playlist = playlist_by_name(playlist)
    end
    track = track.duplicateTo(playlist)
    #    The following does not work:
    #    arg1 = OSX::NSArray.arrayWithArray([track])
    #    puts arg1.class
    #    puts playlist.class
    #    puts @app.add_to_(arg1, playlist)
  end

  def remove_track_from_playlist(track, playlist)
    track.delete
  end

  def create_playlist(name)
    return if playlist_by_name(name) 
    props = {:name => name}
    playlist = @app.classForScriptingClass("playlist").alloc.initWithProperties(props)
    playlists.insertObject_atIndex(playlist, 0)
    playlist
  end

  # This is the playlist that itunes-rails uses
  def queue
    playlist_by_name(QUEUE_PLAYLIST) || create_playlist(QUEUE_PLAYLIST)
  end

  def queue_track(track)
    add_track_to_playlist(track, queue)
  end

  def create_artwork_for_current_track
    # check if it exists
    return if artwork_file(@app.currentTrack)
    return if @app.currentTrack.artworks.empty?
    extension = `osascript -e '
    tell application "iTunes"
      set theTrack to current track
      set artData to (data of artwork 1 of theTrack) as picture
      set artFormat to (format of artwork 1 of theTrack) as string
      
      if artFormat contains "JPEG" then
        set extension to ".jpg"
      else if artFormat contains "PNG" then
        set extension to ".png"
      end if
      set fileName to "test"
      set tempArtFile to "#{RAILS_ROOT}/public/tempfile" & extension
      set fileRef to (open for access tempArtFile write permission 1)
      write artData starting at 0 to fileRef as picture
      close access fileRef
      return extension as string
    end tell' `

    filename = artwork_filename(@app.currentTrack)
    puts filename
    
    `tail -c+223 #{RAILS_ROOT}/public/tempfile.* > #{RAILS_ROOT}/public/artwork/#{filename}#{extension.strip} && rm #{RAILS_ROOT}/public/tempfile.*`
  end

  def artwork_filename(track)
    "%s-%s" % [track.artist.to_s.strip.gsub(/[\W\-_]*/,''), track.album.to_s.strip.gsub(/[\W\-_]*/,'')]
  end

  def artwork_file(track)
    web_path = "/artwork/" + artwork_filename(track) 
    filename = RAILS_ROOT + "/public" + web_path

    return web_path + ".jpg" if File.exist?( filename + ".jpg" )
    return web_path + ".png" if File.exist?( filename + ".png" )
    nil
  end

  def find_songs_without_art
    library.tracks.each do |track|
      if track.artworks.empty?
        puts track.name
      end
    end
  end
end
