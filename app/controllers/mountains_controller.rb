class MountainsController < ApplicationController
  def new
    @mountain = Mountain.new
  end

  def create
    @mountain = Mountain.new(mountain_params)
    @mountain.user_id = current_user.id
    if @mountain.save
      redirect_to mountain_path(@mountain)
    else
      render "new"
    end
  end

  def index
    @mountains = Mountain.all
             .order(created_at: :desc)
             .page(params[:page]).per(10)
  end

  def edit
    @mountain = Mountain.find(params[:id])
    if  @mountain.user == current_user
      render "edit"
    else
      redirect_to mountain_path
    end
  end

  def update
    @mountain = Mountain.find(params[:id])
    if @mountain.update(mountain_params)
      redirect_to mountain_path(@park)
    else
      render "edit"
    end
  end

  def show
    @mountain = Mountain.find(params[:id])
    @user = @mountain.user
  end

  def destroy
    mountain = Mountain.find(params[:id])
    mountain.destroy
    redirect_to mountains_path(mountain.user)
  end

  def mountain_params
    params.require(:mountain).permit(:mountain_image, :mountain_name, :mountain_body, :address, :latitude, :longitude)
  end
end
