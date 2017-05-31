class PasswordResetsController < ApplicationController

  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  #
  #
  # New
  def new
  end

  #
  #
  # Create
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)

    #
    # If the email exist
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to root_url

    #
    else
      flash.now[:danger] = 'Email address not found'
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

    #
    # Blank Passwords
    if password_blank?
      flash[:danger] = 'Password can\'t be blank'
      render 'edit'
    #
    # Updated Password
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = 'Password has been Reset.'
      redirect_to @user
    #
    #
    else
      render 'edit'
    end


  end

  #
  #
  # Private
  private

    #
    #
    # User Params
    def user_params
      params.require(:user).permit(
          :password,
          :password_confirmation
      )
    end

    #
    #
    # Returns true if Password & Confirmation are blank
    def password_blank?
      params[:user][:password].blank?
    end

    # Before Filters

    #
    #
    # Get User
    def get_user
      @user = User.find_by(email: params[:email])
    end

    #
    #
    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    #
    #
    # Check Expiration of reset Token
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = 'Password reset has expired'
        redirect_to new_password_reset_url
      end
    end

end
