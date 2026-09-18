class LibraryMembersController < WebController

  def index
    @members = Member.all
  end

end