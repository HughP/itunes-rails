class SourcesController < ApplicationController

  def index
  end

  def show
    @source = @iTunes.sources[params[:id].to_i]
  end
end
