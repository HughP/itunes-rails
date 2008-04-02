class UsersController < ApplicationController

  def index
  end

  # all this does is plant a cookie
  def create
    session[:username] = params[:username]
    redirect_to :back
  end
end
