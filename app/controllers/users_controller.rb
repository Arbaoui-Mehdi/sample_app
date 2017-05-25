class UsersController < ApplicationController

  #
  #
  # Show
  def show
    @user = User.find(params[:id])
  end

  #
  #
  # New
  def new
    @user = User.new
  end

  #
  #
  # Create
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash.now[:success] = 'Welcome to the Sample App!'
      redirect_to @user
    else
      render 'new'
    end
  end

  #
  #
  #
  # Private Method
  private

    def user_params
      params.require(:user).permit(
          :name,
          :email,
          :password,
          :password_confirmation
      )
    end

end
