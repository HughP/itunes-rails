class TracksController < ApplicationController

  before_filter :find_track
  def queue
    track = @iTunes.find_track(params[:id].to_i)
    track.comment = session[:username] || "" # credit for queuing the song
    track.enabled = true # just in case
    @iTunes.queue_track(track)
    logger.debug "queuing, ITUNES STATE:"
    logger.debug @state

    if @state.strip.to_s == "stopped" 
      logger.debug "TRYING TO PLAY"
      @iTunes.queue.playOnce(1)
      # but need to skip to the head of the queue
      (@queued_tracks.size - 1).times do 
        @iTunes.nextTrack
      end
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { reload_state_data && render( :update ) { | page | page.replace("queue-box", :partial => "queued_tracks/queued_tracks") } } 
    end
  end

  def find_track
    @source = @iTunes.sources[params[:source_id].to_i]
    @playlist = @source.playlists[params[:playlist_id].to_i]
    @track = @playlist.tracks[params[:id].to_i]
  end
end
