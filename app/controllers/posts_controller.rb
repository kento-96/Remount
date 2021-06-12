class PostsController < ApplicationController
  before_action :authenticate_user!
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post)
    else
      render "new"
    end
  end

  def index
    @posts = Post.all
             .order(created_at: :desc) #新しい順に並び替える
             .page(params[:page]).per(10)
  end

  def edit
    @post = Post.find(params[:id])
    if  @post.user == current_user
      render "edit"
    else
      redirect_to posts_path
    end
  end

  def update
     @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      render "edit"
    end
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path(post.user)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end

end
