class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(permit_post)
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

  private
  def permit_post
    params.require(:post).permit( :image, :description)
  end
end
