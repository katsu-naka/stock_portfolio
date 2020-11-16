class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @products = @user.products
  end
end
