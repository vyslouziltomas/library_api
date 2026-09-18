require "csv"

class Borrowing < ApplicationRecord
  belongs_to :book
  belongs_to :member

  validates :action, inclusion: { in: ["borrow", "return"] }

  def self.history
    history = []
    Borrowing.includes(:book, :member).each do |borrowing|
      history << {
        book_title: borrowing.book.title,
        member_name: borrowing.member.name,
        action: borrowing.action,
        created_at: borrowing.created_at
      }
    end
    history
  end

  def self.generate_csv(history)
    output = "\uFEFF"

    output << CSV.generate do |csv|
      csv << ["Titul", "Jméno člena", "Proces", "Datum a čas"]

      history.each do |borrowing|
        csv << [
          borrowing[:book_title],
          borrowing[:member_name],
          borrowing[:action],
          borrowing[:created_at]
        ]
      end
    end

    output
  end

end
