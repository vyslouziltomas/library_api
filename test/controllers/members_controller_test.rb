require "test_helper"

class MembersControllerTest < ActionDispatch::IntegrationTest
  test "GET /api/members returns members" do
    Member.create!(
      name: "Tomáš",
      email: "tomas@example.com",
      phone: "+420111111111"
    )

    get "/api/members"

    assert_response :success
    assert_includes response.parsed_body.to_json, "Tomáš"
  end

  test "POST /api/members creates a member" do
    assert_difference("Member.count", 1) do
      post "/api/members",
        params: {
          member: {
            name: "Petr",
            email: "petr@example.com",
            phone: "+420222222222"
          }
        },
        as: :json
    end

    assert_response :created
    assert_equal "Petr", response.parsed_body["name"]
  end

  test "GET /api/members/:id returns 404 for nonexistent member" do
    get "/api/members/99999"

    assert_response :not_found
    assert_equal "Člen s tímto ID nebyl nalezen.", response.parsed_body["error"]
  end
end