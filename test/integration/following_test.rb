require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  #
  #
  # Setup
  def setup
    @user  = users(:michael)
    @other = users(:archer)
    log_in_as(@user)
  end

  #
  #
  # Following Page
  test 'following page' do
    get following_user_path(@user)
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  #
  #
  # Followers Page
  test 'followers page' do
    get followers_user_path(@user)
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  #
  #
  # Follow - Standard Way
  test 'should follow a user the standard way' do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: {
          followed_id: @other.id
      }
    end
  end

  #
  #
  # Follow - Ajax
  test 'should follow a user using Ajax' do
    assert_difference '@user.following.count', 1 do
      post relationships_path, xhr: true, params: {
          followed_id: @other.id
      }
    end
  end

  #
  #
  # Unfollow - Standard Way
  test 'should unfollow a user the standard way' do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  #
  #
  # Unfollow - Ajax
  test 'should unfollow a user using Ajax' do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end


end
