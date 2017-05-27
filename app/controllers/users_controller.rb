class UsersController < ApplicationController

  #
  #
  # Filters
  before_action :logged_in_user,
                only: [
                    :index,
                    :edit,
                    :update,
                    :destroy
                ]
  before_action :correct_user,
                only: [
                    :edit,
                    :update
                ]
  before_action :admin_user, only: :destroy

  #
  #
  # Index
  def index
    @users = User.paginate(page: params[:page])
  end

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
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account'
      redirect_to root_url
    else
      render 'new'
    end
  end

  #
  #
  # Edit
  def edit
  end

  #
  #
  # Update
  def update
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = 'Profile Updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  #
  #
  # Destroy
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User Deleted'
    redirect_to users_url
  end

  #
  #
  #
  # Private Method
  private

    #
    #
    # User Params
    def user_params
      params.require(:user).permit(
          :name,
          :email,
          :password,
          :password_confirmation
      )
    end

    #
    #
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = 'Please log in.'
        redirect_to login_url
      end
    end

    #
    #
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    #
    #
    # Confirms if the user is an admin
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
