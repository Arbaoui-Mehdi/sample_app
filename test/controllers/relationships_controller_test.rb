require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest

  #
  #
  # Not logged-in - Create
  test 'should redirect create when not logged in' do
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
  end

  #
  #
  # Not logged-in - Delete
  test 'should redirect delete when not logged in' do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
    end
  end

end
