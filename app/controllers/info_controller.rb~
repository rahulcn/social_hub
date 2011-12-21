class InfoController < ApplicationController

  def index
    redirect_to root_path
  end

  def edit
    @title = "edit Info"
    @user = User.find(session[:user_id])
    @user.info ||= info.new
    @info = @user.info
    if info.save
      if @user.info.update_attributes(params[:info])
      redirect_to root_path
      end
    end
  end

end
