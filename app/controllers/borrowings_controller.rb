class BorrowingsController < ApplicationController

  def index
    render json: Borrowing.history
  end

  def export
    history = Borrowing.history
    csv = Borrowing.generate_csv(history)

    send_data csv, filename: "borrowings.csv", type: "text/csv"
  end

end