class QueuedTracksController < ApplicationController

  def index
  end

  def destroy
    # the params :id is an index
    index = params[:id].to_i
    @iTunes.queue.tracks.removeObjectAtIndex(index)
    redirect_to :back
  end

  def playpause
    @iTunes.playpause()
    redirect_to :back
  end

  def skip_current
    @iTunes.nextTrack
    redirect_to :back
  end

  def previous_track
    @iTunes.previousTrack
    redirect_to :back
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
    redirect_to :back
  end

  def toggle_shuffle
    logger.debug "toggling shuffle mode on for queue"
    @iTunes.queue.shuffle = @iTunes.queue.shuffle == 0 ? true : false
    redirect_to :back
  end
end
