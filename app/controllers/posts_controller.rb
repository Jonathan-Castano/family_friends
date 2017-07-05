class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
  def new
    @post = current_user.posts.build
  end

  def index
    @posts = Post.all.order(:cached_votes_score => :desc)
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = current_user.posts.build(permit_post)
    if @post.save
      flash[:success] = "Success!"
      redirect_to post_path(@post)
    else
      flash[:error] = @post.errors.full_messages
      redirect_to new_post_path
    end

  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy!
    redirect_to '/posts', :notice => "Your post has been deleted"
  end

  def upvote
    @post.upvote_from current_user
    redirect_to posts_path
  end

  def downvote
    @post.downvote_from current_user
    redirect_to posts_path
  end

  private

  def set_post
  @post = Post.find(params[:id])
  end

  def permit_post
    params.require(:post).permit( :image, :description)
  end
end
