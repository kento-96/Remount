class PostsController < ApplicationController
  before_action :authenticate_user!
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:tag_names].split(",")
    @post.tags_save(tag_list)
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
    @comments = @post.comments
    @comment = current_user.comments.new
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path(post.user)
  end

  def search
    if params[:search].nil?
      @posts = Post.page(params[:page]).per(10)
                   .order(created_at: :desc)
    else
      @posts = Tag.find_by(tag_name:params[:search]).posts
                   .page(params[:page]).per(10)
      @value = params[:search]
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end

end
