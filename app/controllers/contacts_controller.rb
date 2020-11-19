class ContactsController < ApplicationController
  def index
    @contacts = Contact.where.not(user_id: current_user.id)
  end

  def new
    @user = User.find(params[:user_id])
    @contact = Contact.new
  end
  
  def create
    @contact = Contact.new(contact_params)
    @contact.save
    redirect_to root_path
  end

  def show 
    @contact = Contact.find(params[:id])
  end

  private

  def contact_params
    params.require(:contact).permit(:message).merge(user_id: current_user.id )
  end

end
