class Book < ApplicationRecord
  belongs_to :member, optional: true
  has_many :borrowings
  validates :title, presence: true
  validates :author, presence: true
  validates :year, presence: true
  validates :isbn, presence: true

  def borrow(member)

    return false if member_id.present?

    Book.transaction do
      update!(member: member)
      Borrowing.create!(book: self, member: member, action: "borrow")
    end
  end

  def return_book

    return false unless member_id.present?

    current_member = member

    Book.transaction do
      update!(member_id: nil)
      Borrowing.create!(book: self, member: current_member, action: "return")
    end
  end

  def self.import(books)
    imported_books = []
    errors = []

    books.each do |book_data|
      book = Book.create(
        title: book_data["title"],
        author: book_data["author"],
        year: book_data["year"],
        isbn: book_data["isbn"]
      )

      if book.persisted?
        imported_books << book
      else
        errors << {
          book: book_data,
          errors: book.errors.full_messages
        }
      end
    end

    {
      imported: imported_books,
      errors: errors
    }
  end
  
end
