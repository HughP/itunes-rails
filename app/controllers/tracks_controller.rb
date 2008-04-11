class TracksController < ApplicationController

  before_filter :find_track
  def queue
    # queuing multiple tracks
    if params[:tracks]
      track_ids = params[:tracks].map {|track_id| track_id.to_i}
      # maybe this is slow:
      # TODO try something faster
        
      #tracks = track_ids.collect{ |id| @iTunes.find_track(id) }
      tracks = @iTunes.find_tracks(track_ids)
      logger.debug(tracks.inspect)
      logger.debug "queuing multiple tracks"
      @iTunes.queue_tracks(tracks, session[:username] || "")
    elsif params[:id] && params[:id] != "multiple"  # queuing one track
      track_id = params[:id].to_i
      track = @iTunes.find_track(track_id)
      logger.debug track
      track.enabled = true # just in case
      track.comment = session[:username] || "" # credit for queuing the song
      logger.debug "queuing a track"
      @iTunes.queue_track(track)
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { 
        reload_state_data 
        render( :update ) { | page | 
          page.replace("queue-box", :partial => "queued_tracks/queued_tracks") 
        } 
      } 
    end
  end

  # To get around tricky problems, just allow reordering of stuff ahead of the
  # @current_track_index
  def reorder
    # delete tracks in front of current_track
    indices = OSX::NSIndexSet.indexSetWithIndexesInRange( OSX::NSRange.new(@current_track_index, @iTunes.queue.tracks.length - @current_track_index) )
    @iTunes.queue.tracks.removeObjectsAtIndexes(indices)
    track_ids = params[:queued_tracks].map {|track_id| track_id.to_i}.reverse
    tracks = track_ids.collect{ |id| @iTunes.find_track(id) }
    @iTunes.queue_tracks(tracks, nil)
    logger.debug "reordering tracks"

#   doesn't work:
#    @iTunes.queue.tracks.each_with_index do |track,index|
#      next if index == @current_track_index
#      @iTunes.queue.tracks.replaceObjectAtIndex_withObject(index, tracks[index]) 
#    end

    respond_to do |format|
      format.js { 
        reload_state_data 
        render( :update ) { | page | 
          page.replace("queue-box", :partial => "queued_tracks/queued_tracks") 
        } 
      }
    end
  end

  def find_track
    @source = @iTunes.sources[params[:source_id].to_i]
    @playlist = @source.playlists[params[:playlist_id].to_i]
    @track = @playlist.tracks[params[:id].to_i]
  end
end
