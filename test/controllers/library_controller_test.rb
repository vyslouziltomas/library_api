require "test_helper"

class LibraryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get library_url
    assert_response :success
  end
end
