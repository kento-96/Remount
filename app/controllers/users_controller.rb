class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user=User.find(params[:id])

  end

  def edit
    @user =User.find(params[:id])
    if @user == current_user
      render"edit"
    else
      redirect_to user_path(current_user.id)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
       redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def destroy
  end

  def unsbscribe
  end

  def withdraw
  end

  private

  def user_params
   params.require(:user).permit(:name,:introduction,:profile_image)
  end

end
