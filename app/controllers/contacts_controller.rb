class ContactsController < ApplicationController
  before_action :set_user, only: [:new, :create]

  def index
    @contacts = Contact.where.not(user_id: current_user.id)
  end

  def new
    @contact = Contact.new
  end
  
  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to user_path(@user.id)
    else
      render action: :new
    end
  end

  def show 
    @contact = Contact.find(params[:id])
  end

  private

  def contact_params
    params.require(:contact).permit(:message).merge(user_id: current_user.id )
  end

  def set_user
    @user = User.find(params[:user_id])
  end

end
