require "test_helper"

class BookTest < ActiveSupport::TestCase

  test "book requires a title" do
    book = Book.new(
      author: "George Orwell",
      year: 1949,
      isbn: "9780451524935"
    )

    assert_not book.valid?
  end

  test "book requires an author" do
    book = Book.new(
      title: "1984",
      year: 1949,
      isbn: "9780451524935"
    )

    assert_not book.valid?
  end

  test "book requires a year" do
    book = Book.new(
      title: "1984",
      author: "George Orwell",
      isbn: "9780451524935"
    )

    assert_not book.valid?
  end

  test "book requires an isbn" do
    book = Book.new(
      title: "1984",
      author: "George Orwell",
      year: 1949
    )

    assert_not book.valid?
  end

  test "book can be borrowed" do
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

    assert book.borrow(member)
    assert_equal member.id, book.reload.member_id
  end

  test "borrow creates borrowing history" do
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

    borrowing = Borrowing.last

    assert_equal book.id, borrowing.book_id
    assert_equal member.id, borrowing.member_id
    assert_equal "borrow", borrowing.action
  end

  test "already borrowed book cannot be borrowed again" do
    first_member = Member.create!(
      name: "Tomáš",
      email: "first@example.com",
      phone: "+420111111111"
    )

    second_member = Member.create!(
      name: "Petr",
      email: "second@example.com",
      phone: "+420222222222"
    )

    book = Book.create!(
      title: "1984",
      author: "George Orwell",
      year: 1949,
      isbn: "9780451524935"
    )

    book.borrow(first_member)

    assert_not book.borrow(second_member)
    assert_equal first_member.id, book.reload.member_id
  end

  test "borrowed book can be returned" do
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

    assert book.return_book
    assert_nil book.reload.member_id
  end

  test "return creates borrowing history" do
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
    book.return_book

    borrowing = Borrowing.last

    assert_equal book.id, borrowing.book_id
    assert_equal member.id, borrowing.member_id
    assert_equal "return", borrowing.action
  end

  test "available book cannot be returned" do
    book = Book.create!(
      title: "1984",
      author: "George Orwell",
      year: 1949,
      isbn: "9780451524935"
    )

    assert_not book.return_book
  end

end