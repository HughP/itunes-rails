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

end
