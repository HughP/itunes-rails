class QueuedTracksController < ApplicationController
  skip_before_filter :find_itunes, :get_queue_data, :only => :test_ajax
  before_filter :select_queue_playlist, :except => :reload_queue_box

  def index
  end

  def destroy
    # the params :id is an index
    index = params[:id].to_i
    @iTunes.queue.tracks.removeObjectAtIndex(index)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { reload_state_data && render( :update ) { | page | page.replace("queue-box", :partial => "queued_tracks") } } 
    end
  end

  # Empties the whole queue
  def clear
    @iTunes.queue.tracks.removeAllObjects
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { reload_state_data && render( :update ) { | page | page.replace("queue-box", :partial => "queued_tracks") } } 
    end
  end
  
  # Clears upcoming songs
  def clear_upcoming
    # delete tracks in front of current_track
    indices = OSX::NSIndexSet.indexSetWithIndexesInRange( OSX::NSRange.new(@current_track_index, @iTunes.queue.tracks.length - @current_track_index) )
    @iTunes.queue.tracks.removeObjectsAtIndexes(indices)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { reload_state_data && render( :update ) { | page | page.replace("queue-box", :partial => "queued_tracks") } } 
    end
  end

  def change_volume
    # also set the volume if that is a parameter
    if params[:volume]
      volume = params[:volume].to_i
      if (0..100).include? volume
        @iTunes.soundVolume = volume 
      end
    end
    redirect_to :back 
  end

  def start_queue
    @iTunes.stop
    @iTunes.queue.playOnce(1)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { reload_state_data && render( :update ) { | page | page.replace("queue-box", :partial => "queued_tracks") } } 
    end
  end

  def playpause
    if @state == "stopped"
      @iTunes.queue.playOnce(1)
    else
      logger.debug("pausing")
      @iTunes.playpause()
    end

    # This deals with a bug(?) in AppleScript or the Scripting Bridge.
    if @state == "playing" && @iTunes.currentPlaylist.name.strip != ITunes::QUEUE_PLAYLIST
      logger.debug "restarting queue"
      @iTunes.queue.playOnce(1)
    end
    respond_to do |format|
      format.js do
        reload_state_data 
        render( :update ) { | page | page.replace("queue-box", :partial => "queued_tracks") } 
      end
      format.html { redirect_to :back }
    end
  end

  def skip_current
    # Needs to be in play mode for nextTrack()
    @iTunes.playpause if @state == "paused"
    @iTunes.nextTrack
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { reload_state_data && render( :update ) { | page | page.replace("queue-box", :partial => "queued_tracks") } } 
    end
  end

  def reload_queue_box
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { 
        reload_state_data 
        render( :update ) { | page | 
          page.replace("queue-box", :partial => "queued_tracks") 
        } 
      } 
    end
  end

  def previous_track
    # Needs to be in play mode for nextTrack()
    @iTunes.playpause if @state == "paused"
    @iTunes.previousTrack
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { reload_state_data && render( :update ) { | page | page.replace("queue-box", :partial => "queued_tracks") } } 
    end
  end

  def play_now
    index = params[:id].to_i
    if @state.strip.to_s != "playing"
      logger.debug "Trying to start playlist..."
    end
    # user is just changing volume, skip this
    # TODO refactor this to be more straightforward
    unless params[:volume]
      @iTunes.stop
      @iTunes.queue.playOnce(1)
      # There is no way in the Scripting Bridge API to starting playing a track directly as part
      # of the track (rather than as the track itself, in which case, the playing stops after the 
      # track finishes).
      #
      # I tried a different way of doing this (see an earlier version of this
      # code), but there were issues with it.  I'll try to make this more
      # elegant later. But now I'm opting for slow but less buggy.
      index.times do 
        @iTunes.nextTrack
      end
      @iTunes.create_artwork_for_current_track
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { reload_state_data && render( :update ) { | page | page.replace("queue-box", :partial => "queued_tracks") } } 
    end
  end

  def toggle_shuffle
    logger.debug "toggling shuffle mode on for queue"
    @iTunes.queue.shuffle = @iTunes.queue.shuffle == 0 ? true : false
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { reload_state_data && render( :update ) { | page | page.replace("queue-box", :partial => "queued_tracks") } } 
    end
  end

end
