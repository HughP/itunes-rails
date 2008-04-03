class UsersController < ApplicationController

  def index
  end

  # all this does is plant a cookie
  def create
    session[:username] = params[:username]
    respond_to do |format|
      format.js { render( :update ) { | page | page.replace("queue-box", :partial => "queued_tracks/queued_tracks") } } 
      format.html { redirect_to :back }
    end
  end
end
