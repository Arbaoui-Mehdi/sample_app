require 'test_helper'
require 'awesome_print'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  #
  #
  # Setup
  def setup
    @user = users(:michael)
  end

  #
  #
  #
  test 'micropost interface' do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'

    #
    # Invalid Submission
    post microposts_path, params: {
        micropost: {
            content: ''
        }
    }
    assert_select 'div#error_explanation'

    #
    # Valid Submission
    content = 'This Micropost really ties the room together'
    post microposts_path, params: {
        micropost: {
            content: content
        }
    }
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

    #
    # Delete a Post
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_select 'a', text: 'delete'
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    #
    # Visiting a Different User
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0

  end

end
