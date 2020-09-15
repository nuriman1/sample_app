class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, except: %i(edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: destroy

  def index
    @users = User.page(params[:page]).per Settings.per_page
  end
  
  def show
    @user = User.find_by id: params[:id]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      flash[:danger] = "Please try again"
      render :new
    end
  end

  def edit
    @user = User.find_by params[:id]
    if @user.edit user_params
      flash.now[success] = "User found"
      render :edit
    else
      flash[:danger] = "User not found"
      redirect_to root_url
    end
  end


  def update
    @user = User.find_by params[:id]
    if @user.update user_params
      flash.now[:success] = "Profile updated"
      redirect_to @user
    else
      flash.now[:success] = "Profile is not updated"
      render :edit
    end
  end

  def destroy
    User.find_by params[:id].destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def load_user
    @user = User.find_by params[:id]
    return unless @user

    flash[:danger] = "User not found"
    redirect_to root_url
  end

  def correct_user
    @user = User.find_by params[:id]
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
