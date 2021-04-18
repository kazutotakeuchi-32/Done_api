require "test_helper"

class Api::V1::Users::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get api_v1_users_users_show_url
    assert_response :success
  end
end
