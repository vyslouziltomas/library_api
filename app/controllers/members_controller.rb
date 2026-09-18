class MembersController < ApplicationController
  
  def member_params
    params.require(:member).permit(:name, :email, :phone)
  end

  def index
    members = Member.all
    render json: members
  end

  def show
    begin
      member = Member.find(params[:id])
      render json: member
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Člen s tímto ID nebyl nalezen." }, status: :not_found
    end
  end

  def create
    member = Member.create(member_params)
    if member.valid?
      render json: member, status: :created
    else
      render json: { errors: member.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    begin
      member = Member.find(params[:id])
      if member.update(member_params)
        render json: member
      else
        render json: { errors: member.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Člen s tímto ID nebyl nalezen." }, status: :not_found
    end
  end

  def destroy
    begin
      member = Member.find(params[:id])
      member.destroy

      head :no_content
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Člen s tímto ID nebyl nalezen." }, status: :not_found
    end
  end

  def import
    members = params[:members]
    imported_members = []
    errors = []

    members.each do |member_data|
      member = Member.create(
        name: member_data["name"],
        email: member_data["email"],
        phone: member_data["phone"]
      )

      if member.persisted?
        imported_members << member
      else
        errors << {
          member: member_data,
          errors: member.errors.full_messages
        }
      end
    end
    render json: {
      imported: imported_members,
      errors: errors
    }
  end

end