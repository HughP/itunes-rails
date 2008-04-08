class TracksController < ApplicationController

  before_filter :find_track
  def queue
    start_playing_at_index = @queued_tracks.size  # might use this later
    # queuing multiple tracks
    if params[:tracks]
      track_ids = params[:tracks].map {|track_id| track_id.to_i}
      tracks = track_ids.collect{ |id| @iTunes.find_track(id) }
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
    if @state.strip.to_s == "stopped" 
      logger.debug "TRYING TO PLAY"
      @iTunes.queue.playOnce(1)
      # but need to skip to the head of the queue, unless multiple track add
      start_playing_at_index.times do 
        @iTunes.nextTrack
      end
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

  def reorder
    @iTunes.clear_queue
    track_ids = params[:queued_tracks].map {|track_id| track_id.to_i}.reverse
    tracks = track_ids.collect{ |id| @iTunes.find_track(id) }
    logger.debug "reordering tracks"
    @iTunes.queue_tracks(tracks)
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
