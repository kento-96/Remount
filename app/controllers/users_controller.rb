class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user=User.find(params[:id])
    @posts=@user.posts.all
                .order(created_at: :desc) #新しい順に並び替える
                 .page(params[:page]).per(6)
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
    @user = User.find(params[:id])
  end

  def withdraw
    @user = User.find(params[:id])
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "ありがとうございました。またのご利用を心よりお待ちしております。"
    redirect_to about_path
  end

  private

  def user_params
   params.require(:user).permit(:name,:introduction,:profile_image)
  end

end
