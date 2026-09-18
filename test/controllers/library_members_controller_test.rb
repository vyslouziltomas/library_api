require "test_helper"

class LibraryMembersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get members_url
    assert_response :success
  end
end
