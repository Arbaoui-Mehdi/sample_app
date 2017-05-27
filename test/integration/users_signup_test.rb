require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  #
  #
  # Setup
  def setup
    ActionMailer::Base.deliveries.clear
  end

  #
  #
  # Invalid Sign Up
  test 'invalid sign up information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
          user: {
              name: '',
              email: 'user@invalid',
              password: 'foo',
              password_confirmation: 'bar',
          }
      }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  #
  #
  # Valid Sign Up
  test 'valid sign up information' do
    get signup_path
    assert_difference'User.count', 1 do
      post users_path, params: {
          user: {
              name:                  'John Doe',
              email:                 'john_doe@gmail.com',
              password:              'foobar',
              password_confirmation: 'foobar'
          }
      }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?

    #
    #
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?

    # Invalid Activation Token
    get edit_account_activation_path('invalid_token')
    assert_not is_logged_in?
    # Wrong Email
    get edit_account_activation_path(user.activation_token, email:'wrong')
    assert_not is_logged_in?
    # Correct Token and Email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert is_logged_in?
    assert user.reload.activated?

    # Redirection after User Activation
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end
