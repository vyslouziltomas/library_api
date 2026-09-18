require "test_helper"

class BorrowingTest < ActiveSupport::TestCase

  test "history returns borrowing data" do
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

    history = Borrowing.history

    borrowing = history.find do |entry|
      entry[:book_title] == "1984" &&
        entry[:member_name] == "Tomáš" &&
        entry[:action] == "borrow"
    end

    assert_not_nil borrowing
    assert_not_nil borrowing[:created_at]
  end

  test "generate_csv creates csv data" do
    history = [
      {
        book_title: "1984",
        member_name: "Tomáš",
        action: "borrow",
        created_at: Time.utc(2026, 9, 15, 10, 30, 0)
      }
    ]

    csv = Borrowing.generate_csv(history)

    assert_includes csv, "Titul,Jméno člena,Proces,Datum a čas"
    assert_includes csv, "1984,Tomáš,borrow,2026-09-15 10:30:00 UTC"
  end

end