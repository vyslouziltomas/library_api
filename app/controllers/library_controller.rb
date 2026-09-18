class LibraryController < WebController

  def index
    @books = Book.all
    @members = Member.all
  end

  def return_book
    book = Book.find(params[:id])
    book.return_book

    redirect_to library_path
  end

  def borrow
    book = Book.find(params[:id])

    return redirect_to(library_path) if params[:member_id].blank?

    member = Member.find(params[:member_id])
    book.borrow(member)
    
    redirect_to library_path
  end

end
