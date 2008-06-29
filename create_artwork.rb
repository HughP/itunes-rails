
source = ITUNES.sources[0]
# just assume this is source 0 (Library)
#playlist = Playlist.find_by_index(params[:id]) 
playlist = source.playlists[1] 
playlist.tracks.each do |x|
  puts "creating artwork for #{x.name}"
  ITUNES.create_artwork_for_track(x)
end

