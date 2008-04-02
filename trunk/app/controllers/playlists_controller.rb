class PlaylistsController < ApplicationController

  before_filter :find_playlist

  def show
    order = params[:order] || nil 

    # User is submitting a search query
    more = nil
    if params[:q] && !params[:q].blank? 
      @tracks = @playlist.searchFor_only(params[:q], nil)
    else
      # no search, just list
      if order
        @tracks = @playlist.tracks.sort_by {|t| t.send(order)}[0,500]
      else
        @offset = (params[:offset] || 0).to_i
        @limit = 500
        @tracks = @playlist.tracks[@offset,@limit]
        @total = @playlist.tracks.size 
        @more = [@total - @offset, @limit].min
      end
    end
  end

  def index
  end

  def find_playlist
    @source = @iTunes.sources[params[:source_id].to_i]
    # just assume this is source 0 (Library)
    #@playlist = Playlist.find_by_index(params[:id]) 
    @playlist = @source.playlists[params[:id].to_i] 
  end
end

