class AdminController < WebController

  def index
    @books = Book.all
    @members = Member.all
    @history = Borrowing.history.reverse
  end

  def create_book
    book = Book.create(
      title: params[:title],
      author: params[:author],
      year: params[:year],
      isbn: params[:isbn]
    )

    if book.persisted?
      redirect_to admin_path
    else
      @books = Book.all
      @members = Member.all
      @history = Borrowing.history.reverse
      @new_book = book
      @book_form_errors = book.errors.full_messages

      render :index, status: :unprocessable_entity
    end
  end

  def edit_book
    @book = Book.find(params[:id])
    @books = Book.all
  end

  def update_book
    book = Book.find(params[:id])

    if book.update(
      title: params[:title],
      author: params[:author],
      year: params[:year],
      isbn: params[:isbn]
    )
      redirect_to admin_path
    else
      @books = Book.all
      @members = Member.all
      @history = Borrowing.history.reverse
      @edit_book_errors = book.errors.full_messages
      @edit_book_id = book.id

      render :index, status: :unprocessable_entity
    end
  end

  def delete_book
    book = Book.find(params[:id])

    if book.member_id.present?
      redirect_to admin_path
    else
      book.borrowings.destroy_all
      book.destroy

      redirect_to admin_path
    end
  end

  def import_books
    file = params[:file]

    if file.nil?
      @books = Book.all
      @members = Member.all
      @import_errors = ["Nebyl vybrán žádný soubor."]
      @show_book_import = true

      render :index, status: :unprocessable_entity
      return
    end

    begin
      books = JSON.parse(file.read)
    rescue JSON::ParserError
      @books = Book.all
      @members = Member.all
      @import_errors = ["Soubor neobsahuje platný JSON."]
      @show_book_import = true

      render :index, status: :unprocessable_entity
      return
    end

    unless books.is_a?(Array)
      @books = Book.all
      @members = Member.all
      @import_errors = ["JSON musí obsahovat seznam knih."]
      @show_book_import = true

      render :index, status: :unprocessable_entity
      return
    end

    result = Book.import(books)

    if result[:errors].any?
      @books = Book.all
      @members = Member.all
      @import_errors = result[:errors]
      @show_book_import = true

      render :index, status: :unprocessable_entity
    else
      redirect_to admin_path
    end
  end

  def create_member
    member = Member.create(
      name: params[:name],
      email: params[:email],
      phone: params[:phone]
    )

    if member.persisted?
      redirect_to admin_path(section: "members")
    else
      @books = Book.all
      @members = Member.all
      @history = Borrowing.history.reverse
      @new_member = member
      @member_form_errors = member.errors.full_messages
      @active_section = "members"

      render :index, status: :unprocessable_entity
    end
  end

  def update_member
    member = Member.find(params[:id])

    if member.update(
      name: params[:name],
      email: params[:email],
      phone: params[:phone]
    )
      redirect_to admin_path(section: "members")
    else
      @books = Book.all
      @members = Member.all
      @history = Borrowing.history.reverse
      @edit_member_id = member.id
      @edit_member_errors = member.errors.full_messages
      @active_section = "members"

      render :index, status: :unprocessable_entity
    end
  end

  def delete_member
    member = Member.find(params[:id])

    member.borrowings.destroy_all
    member.destroy

    redirect_to admin_path(section: "members")
  end

  def export_history
    history = Borrowing.history
    csv = Borrowing.generate_csv(history)

    send_data csv, filename: "borrowings.csv", type: "text/csv"
  end

  def delete_history
    Borrowing.delete_all

    redirect_to admin_path(section: "history")
  end

end