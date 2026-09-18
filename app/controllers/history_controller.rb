class HistoryController < WebController

  def index
    @history = Borrowing.history.reverse
  end

  def export
    history = Borrowing.history.reverse
    csv = Borrowing.generate_csv(history)

    send_data csv, filename: "borrowings.csv", type: "text/csv"
  end

  def destroy
    Borrowing.delete_all

    redirect_to history_path
  end
  
end