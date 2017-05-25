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
      # Log the user in and redirect to the user's show page
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user

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
