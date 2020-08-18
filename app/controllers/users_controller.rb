class UsersController < ApplicationController
  def new; end
  
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = "User not found"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      flash[:danger] = "Please try again"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password_confirmation
  end
end