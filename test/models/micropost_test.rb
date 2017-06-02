require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  #
  #
  # Setup
  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: 'Lorem Ipsum')
  end

  #
  #
  #
  test 'should be valid' do
    assert @micropost.valid?
  end

  #
  #
  # User ID Presence
  test 'user id should be present' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  #
  #
  # Content Presence
  test 'content should be present' do
    @micropost.content = ' '
    assert_not @micropost.valid?
  end

  #
  #
  # Content Max Length 140
  test 'content should be at most 140 characters' do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end

  #
  #
  # Recent Micropost
  test 'order should be most recent first' do
    assert_equal Micropost.first, microposts(:most_recent)
  end

end
