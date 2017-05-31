class StaticPagesController < ApplicationController

  #
  #
  # Home Page
  def home
    if logged_in?
      @micropost  = current_user.microposts.build if logged_in?
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  #
  #
  # Help
  def help

  end

  #
  #
  # About
  def about

  end

  #
  #
  # Contact
  def contact

  end

end


