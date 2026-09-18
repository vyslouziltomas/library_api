require "test_helper"

class BorrowingsControllerTest < ActionDispatch::IntegrationTest
  test "GET /api/borrowings returns borrowing history" do
    member = Member.create!(
      name: "Tomáš",
      email: "tomas@example.com",
      phone: "+420111111111"
    )

    book = Book.create!(
      title: "1984",
      author: "George Orwell",
      year: 1949,
      isbn: "9780451524935"
    )

    book.borrow(member)

    get "/api/borrowings"

    assert_response :success
    assert_includes response.parsed_body.to_json, "1984"
    assert_includes response.parsed_body.to_json, "Tomáš"
    assert_includes response.parsed_body.to_json, "borrow"
  end

  test "GET /api/borrowings/export returns csv file" do
    get "/api/borrowings/export"

    assert_response :success
    assert_equal "text/csv", response.media_type
    assert_includes response.body, "Titul,Jméno člena,Proces,Datum a čas"
  end
end