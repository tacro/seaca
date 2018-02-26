 class PostsController < ApplicationController
before_action :authenticate_user
before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index
    @posts=Post.all.order(created_at: :desc)
  end

  def show
    @post = Post.find_by(id: params[:id]) #first id is column's, second is just a variable from router
    @user = @post.user
    @likes_count = Like.where(post_id: @post.id).count
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(
      content: params[:content],
      user_id: @current_user.id
    )
    #cretating new post which content is get from params[:content(name tag of textarea)]
    if @post.save
      flash[:notice] = "投稿しました"
      redirect_to("/posts/index")
      NotificationMailer.post_email(@current_user).deliver
    else
      render("posts/new")
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]
    if @post.save
      flash[:notice] = "投稿を編集しました"
      redirect_to("/posts/index")
    else
      render("posts/edit")
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/posts/index")
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @current_user.id != @post.user_id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

end
