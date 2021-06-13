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

  def unsubscribe
    @user = current_user
  end

  def withdraw
    @user = User.find(params[:id])
    #is_deletedカラムにフラグを立てる(defaultはfalse)
    @user.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end

  private

  def user_params
   params.require(:user).permit(:name,:introduction,:profile_image)
  end

end
