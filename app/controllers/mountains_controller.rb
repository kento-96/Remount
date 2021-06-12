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
  end

  def edit
  end

  def update
  end

  def show
  end

  def destroy
  end

  def park_params
    params.require(:mountain).permit(:mountain_image, :mountain_name, :mountain_body, :address, :latitude, :longitude)
  end
end
