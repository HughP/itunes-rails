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

  def playpause
    logger.debug("MARK A")
    @iTunes.playpause()
    logger.debug("MARK A")
    respond_to do |format|
      format.js do
        logger.debug("MARK B")
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
      @iTunes.stop
      @iTunes.queue.playOnce(1)
      index.times do 
        @iTunes.nextTrack
      end
    else
      if @current_track_index - 1 < index
        (index - @current_track_index + 1).times do 
          @iTunes.nextTrack
        end
      else #rewind
        (@current_track_index - index - 1).times do 
          @iTunes.previousTrack
        end
      end
    end

    @iTunes.create_artwork_for_current_track
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
