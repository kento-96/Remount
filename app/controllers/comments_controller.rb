class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @post = Post.find(params[:post_id])
    comment = Comment.new(comment_params)
    comment.post_id = @post.id
    comment.user_id = current_user.id
    comment.save
    # redirect_to post_path(@post)
  end

  def destroy
    @post = Post.find(params[:post_id])
    @post_comment = Comment.find(params[:id])
    @post_comment.destroy
    # Comment.find_by(id: params[:id], post_id: params[:post_id]).destroy
    # redirect_to post_path(params[:post_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
