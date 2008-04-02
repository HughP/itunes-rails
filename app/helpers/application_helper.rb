# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # includes the current request parameters
  def url_for_with_current_params(new_params={})
    old_params = params
    url_for(old_params.merge(new_params))
  end
end
