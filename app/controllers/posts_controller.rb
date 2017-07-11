class PostsController < ApplicationController
  skip_before_action :authenticate_user, only: [ :index, :show ]

  before_action :authorize_admin, except: [ :index, :show ]

  def index
    @main_posts = Post.where(rank: 1).limit(4).order(created_at: :desc)
    @secondary_posts = Post.where(rank: 1).limit(3).order(created_at: :desc)
    @minor_posts = Post.where(rank: 4).limit(5).order(created_at: :desc)
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to @post
    else
      render :new
    end
  end

  def edit
    set_post
  end

  def show
    set_post

    @comments = @post.comments.order(:created_at)
    @best_comment = @post.best_comment
  end

  def update
    set_post

    if @post.update_attributes(post_params)
      redirect_to @post
    else
      render :edit
    end
  end
  
  def change_rank
    # ...
  end

  def list
    @posts = Post.all
  end

  def destroy
    set_post

    @post.destroy

    redirect_to posts_path
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :summary, :image, :rank)
  end
end
