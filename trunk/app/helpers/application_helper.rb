# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # includes the current request parameters
  def url_for_with_current_params(new_params={})
    old_params = params
    url_for(old_params.merge(new_params))
  end

  def album_art_image_tag
    return if @state == "stopped"
    # if paused, the track can be determined from current_track_index, so we
    # use it for both states
    logger.debug "current track for art: #{@current_track}"
    path = @iTunes.artwork_file(@current_track) 
    if path
      image_tag( path, :size => "200x200")
    else
      "<p>There is no artwork for the current song.</p>"
    end
  end
end
