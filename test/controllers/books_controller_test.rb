require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  test "PATCH /api/books/:id/borrow borrows an available book" do
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

    patch "/api/books/#{book.id}/borrow",
      params: { member_id: member.id },
      as: :json

    assert_response :success
    assert_equal member.id, response.parsed_body["member_id"]
  end

  test "PATCH /api/books/:id/return_book returns a borrowed book" do
    member = Member.create!(
      name: "Tomáš",
      email: "tomas@example.com",
      phone: "+420111111111"
    )

    book = Book.create!(
      title: "1984",
      author: "George Orwell",
      year: 1949,
      isbn: "9780451524935",
      member: member
    )

    patch "/api/books/#{book.id}/return_book",
      as: :json

    assert_response :success
    assert_nil response.parsed_body["member_id"]
  end

  test "GET /api/books returns books" do
    Book.create!(
      title: "1984",
      author: "George Orwell",
      year: 1949,
      isbn: "9780451524935"
    )

    get "/api/books"

    assert_response :success
    assert_includes response.parsed_body.to_json, "1984"
  end

  test "POST /api/books creates a book" do
    assert_difference("Book.count", 1) do
      post "/api/books",
        params: {
          book: {
            title: "Duna",
            author: "Frank Herbert",
            year: 1965,
            isbn: "9780441172719"
          }
        },
        as: :json
    end

    assert_response :created
    assert_equal "Duna", response.parsed_body["title"]
  end

  test "GET /api/books/:id returns 404" do
    get "/api/books/99999"

    assert_response :not_found
    assert_equal "Kniha s tímto ID nebyla nalezena.", response.parsed_body["error"]
  end

  test "POST /api/books/import imports valid books" do
    assert_difference("Book.count", 2) do
      post "/api/books/import",
        params: {
          books: [
            {
              title: "Duna",
              author: "Frank Herbert",
              year: 1965,
              isbn: "9780441172719"
            },
            {
              title: "Hobit",
              author: "J. R. R. Tolkien",
              year: 1937,
              isbn: "9780261102217"
            }
          ]
        },
        as: :json
    end

    assert_response :success
    assert_equal 2, response.parsed_body["imported"].length
    assert_empty response.parsed_body["errors"]
  end
end