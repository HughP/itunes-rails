class PlaylistsController < ApplicationController

  before_filter :find_playlist

  def show
    order = params[:order] || nil 

    # User is submitting a search query
    more = nil
    if params[:q] && !params[:q].blank? 
      @tracks = @playlist.searchFor_only(params[:q], nil)
    elsif artist=params[:artist]
      # This is too slow:
      #predicate = OSX::NSPredicate.predicateWithFormat("artist == '#{artist}'")
      #@tracks = @playlist.tracks.filteredArrayUsingPredicate(predicate)
      category_code = 'kSrR'.unpack("H*").first.hex # artists field search
      @tracks = @playlist.searchFor_only(params[:artist], category_code)
    else
      # no search, just list
      @offset = (params[:offset] || 0).to_i
      @limit = 500
      if order
        @tracks = @playlist.tracks.sort_by {|t| t.send(order)}[@offset,@limit]
        #@tracks = @playlist.tracks.sortedArrayUsingSelector(order.to_sym)[@offset,@limit]
      else
        @tracks = @playlist.tracks[@offset,@limit]
      end
      @total = @playlist.tracks.size 
      @more = [@total - @offset, @limit].min
    end
  end

  def index
  end

  private
  def find_playlist
    @source = @iTunes.sources[params[:source_id].to_i]
    # just assume this is source 0 (Library)
    #@playlist = Playlist.find_by_index(params[:id]) 
    @playlist = @source.playlists[params[:id].to_i] 
  end

end

