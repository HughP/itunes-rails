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
    @current_track_index
    index = params[:id].to_i
    if @state.strip.to_s == "stopped"
      @iTunes.queue.playOnce(1)
    end
    if @current_track_index - 1 < index
      (index - @current_track_index + 1).times do 
        @iTunes.nextTrack
      end
    else #rewind
      (@current_track_index - index - 1).times do 
        @iTunes.previousTrack
      end
    end
    redirect_to :back
  end

end
