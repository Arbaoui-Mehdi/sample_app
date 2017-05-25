require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  #
  #
  # Setup
  def setup
    @user = users(:michael)
    remember(@user)
  end

  #
  #
  # Current User
  test 'current_user returns right user when session i nit' do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test 'current_user returns nil when digest is wrong' do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

end