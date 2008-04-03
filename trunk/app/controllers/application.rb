# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :find_itunes, :get_queue_data
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
#  protect_from_forgery # :secret => '3eab6503a5d8993ac2a3fa6ff8ef072b'


  # This is called toward the end of ajax actions
  def reload_state_data
    find_itunes
    get_queue_data
  end

  def find_itunes
    @iTunes ||= ITUNES #OSX::SBApplication.applicationWithBundleIdentifier_("com.apple.iTunes")
    @state = `osascript -e 'tell application "iTunes" to player state as string'`
    @state.strip!
    logger.debug "STATE: #{@state}"

    # also set the volume if that is a parameter
    if params[:volume]
      volume = params[:volume].to_i
      if (0..100).include? volume
        @iTunes.soundVolume = volume 
      end
    end
  end

  def get_queue_data
    @queued_tracks = @iTunes.queue.tracks

    # get current track index, but check for status first?
    # or just use error handling
    if @state.to_s.strip != 'stopped'
      @current_track_index = `osascript -e 'tell application "iTunes" to index of current track as string'`.to_i
    else
      logger.debug "Setting current track index to 0"
      @current_track_index = 0
    end
    logger.debug "CURRENT TRACK"
    logger.debug @current_track_index
  end
end
