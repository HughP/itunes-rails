class QueuedTracksController < ApplicationController
  skip_before_filter :find_itunes, :get_queue_data, :only => :test_ajax

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
