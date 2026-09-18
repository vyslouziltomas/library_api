class BooksController < ApplicationController
  
  def book_params
    params.require(:book).permit(:title, :author, :year, :isbn)
  end

  def index
    books = Book.all
    render json: books
  end

  def show
    begin
      book = Book.find(params[:id])
      render json: book
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Kniha s tímto ID nebyla nalezena." }, status: :not_found
    end
  end

  def create
    book = Book.create(book_params)
    if book.valid?
      render json: book, status: :created
    else
      render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def borrow
    begin
      book = Book.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Kniha s tímto ID nebyla nalezena." }, status: :not_found
      return
    end

    begin
      member = Member.find(params[:member_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Člen s tímto ID nebyl nalezen." }, status: :not_found
      return
    end

    if book.borrow(member)
      render json: book
    else
      render json: { error: "Kniha je již půjčená." }, status: :unprocessable_entity
    end
  end

  def return_book
    begin
      book = Book.find(params[:id])
      if book.return_book
        render json: book
      else
        render json: { error: "Knihu momentálně nikdo nemá zapůjčenou" }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Kniha s tímto ID nebyla nalezena." }, status: :not_found
    end
  end

  def update
    begin
      book = Book.find(params[:id])
      if book.update(book_params)
        render json: book
      else
        render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Kniha s tímto ID nebyla nalezena." }, status: :not_found
    end
  end

  def destroy
    begin
      book = Book.find(params[:id])
      book.destroy

      head :no_content
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Kniha s tímto ID nebyla nalezena." }, status: :not_found
    end
  end

  def import
    books = params[:books]

    result = Book.import(books)

    render json: result
  end
  
end
