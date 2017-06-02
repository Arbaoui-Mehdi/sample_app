require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  #
  #
  # Setup
  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  #
  #
  # Index Page - admin
  test 'index as admin including pagination and delete link' do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'ul.pagination'
    first_page_of_users = User.paginate(page:1)
    first_page_of_users.each do |user|

      assert_select 'a[href=?]',
                    user_path(user),
                    text: user.name

      unless user == @admin
        assert_select 'a[href=?]',
                      user_path(user),
                      text: 'delete',
                      method: :delete
      end
    end
  end

  # 
  # 
  # Index Page - non-admin
  test 'should not contain delete link for non-admin users' do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

end
