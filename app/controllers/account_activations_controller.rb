class AccountActivationsController < ApplicationController

  #
  #
  # Edit
  def edit
    user = User.find_by(email: params[:email])

    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      #
      #
      # Activate the user
      user.activate
      log_in user
      flash[:success] = 'Account Activated'
      redirect_to user

    else
      #
      #
      # Handle invalid Link
      flash[:danger] = 'Invalid activation Link'
      redirect_to root_url
    end

  end

end
