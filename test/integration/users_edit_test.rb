require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  #
  #
  # Setup
  def setup
    # Get the user from the fixture
    @user = users(:michael)
  end

  #
  #
  # Update User Infos - Unsuccessful
  test 'unsuccessful user update' do
    get edit_user_path(@user)
    log_in_as(@user)
    patch user_path(@user), params: {
        user: {
            name:                  '',
            email:                 'user@invalid',
            password:              'foo',
            password_confirmation: 'bar',
        }
    }
    assert_template 'users/edit'
  end

  #
  #
  # Update User Infos - Successful
  test 'successful user update with friendly forwarding' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = 'Michael Hartl'
    email = 'whithat88@gmail.com'
    patch user_path(@user), params: {
        user: {
            name:                  name,
            email:                 email,
            password:              '',
            password_confirmation: ''
        }
    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end


end
