class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to the Simple Blog, #{@user.username}!"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = "Your profile was successfully updated!"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end
  
  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end
  
  def destroy
    username = @user.username
    @user.destroy
    flash[:danger] = "The account and all articles created by #{username} have been deleted."
    redirect_to users_path
  end
  
  private
    def set_user
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
    
    def require_same_user
      if current_user != @user and !current_user.admin?
        flash[:danger] = "You can only edit your own profile!"
        redirect_to root_path
      end
    end
    
    def require_admin
      if logged_in? and !current_user.admin?
        flash[:danger] = "Only administrators can perform that action."
        redirect_to root_path
      end
    end
end