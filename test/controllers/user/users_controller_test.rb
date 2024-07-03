require "test_helper"

class User::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_users_index_url
    assert_response :success
  end

  test "should get unsubscribe" do
    get user_users_unsubscribe_url
    assert_response :success
  end
end
