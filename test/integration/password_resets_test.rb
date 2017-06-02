require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  #
  #
  # Setup
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  #
  #
  # Password Resets
  test 'password resets' do
    get new_password_reset_path
    assert_template 'password_resets/new'

    #
    #
    # Invalid email
    post password_resets_path, params: {
        password_reset: { email: '' }
    }
    assert_not flash.empty?
    assert_template 'password_resets/new'

    #
    #
    # Valid Email
    post password_resets_path, params: {
        password_reset: { email: @user.email }
    }
    assert_not flash.empty?
    assert_redirected_to root_url
    # updated digest
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    # email delivered
    assert_equal 1, ActionMailer::Base.deliveries.size

    #
    #
    # Password reset Form
    user = assigns(:user)

    #
    # Right Token, Wrong Email
    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_url

    #
    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)

    #
    # Right Email, Wrong Token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url

    #
    # Right Email, Right Token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email

    #
    # Invalid Password & Confirmation
    patch password_reset_path(user.reset_token), params: {
        email: user.email,
        user: {
            password: 'foobar',
            password_confirmation: 'bazfoo'
        }
    }
    assert_select 'div#error_explanation'

    #
    # Blank Password
    patch password_reset_path(user.reset_token), params: {
        email: user.email,
        user: {
            password: ' ',
            password_confirmation: 'foobar'
        }
    }
    assert_not flash.empty?
    assert_template 'password_resets/edit'

    #
    # Valid Password & Confirmation
    patch password_reset_path(user.reset_token), params: {
        email: user.email,
        user: {
            password: 'foobar',
            password_confirmation: 'foobar'
        }
    }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user

  end

end
