class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:index,:show,:edit,:update]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :ensure_correct_user, {only: [:edit, :update]}
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    user = params.require(:user).permit(
      :name,
      :email,
      :password
    )
    @user = User.new(user)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to("/")
      NotificationMailer.signup_email(@user).deliver
    else
      render("users/new")
    end
  end

  def login_form
    @user = User.new
  end

  def login
    @user = User.find_by(
      email: params[:email]
    )
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
     end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    user = params.require(:user).permit(
      :name,
      :email,
      :avatar
    )
    if @user.update_attributes(user)
      flash[:notice]="ユーザー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end

  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

  def likes
    @user = User.find_by(id: params[:id])
    @likes = Like.where(user_id: @user.id)
  end

end
