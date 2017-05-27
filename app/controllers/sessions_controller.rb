class SessionsController < ApplicationController

  #
  #
  # New Session
  def new
  end

  #
  #
  # Log In
  def create
    #
    #
    # Find user by email
    user = User.find_by(email: params[:session][:email])

    #
    #
    # If user exist
    if user && user.authenticate(params[:session][:password])
      # If user is activated
      if user.activated?
        # Log the user in and redirect to the user's show page
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user

      # if user is not activated
      else
        message = 'Account not activated.'
        message += 'Check your email for the activation link.'
        flash[:warning] = message
        redirect_to root_path
      end

    #
    #
    # If user does not exist
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end

  end

  #
  #
  # Log Out
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
