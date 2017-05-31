require 'test_helper'
require 'awesome_print'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  #
  #
  # Setup
  def setup
    @micropost = microposts(:orange)
  end

  #
  #
  # Create Micropost - Not Logged In
  test 'should redirect create when not logged-in' do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: {
        content: 'Lorem Ipsum'
      }
    end
    assert_redirected_to login_url
  end

  #
  #
  # Delete Micropost - Not Logged In
  test 'should redirect destroy when not logged-in' do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  #
  #
  # Deleting others users microposts
  test 'should redirect destroy for wrong micropost' do
    log_in_as(users(:michael))
    assert_no_difference 'Micropost.count' do
      delete micropost_path(microposts(:ants))
    end
  end

end
