require "test_helper"

class User::RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_relationships_index_url
    assert_response :success
  end
end
