class LikesController < ApplicationController
  before_action :product_params

  def create
    Like.create(user_id: current_user.id, product_id: params[:id])
  end

  def destroy
    Like.find_by(user_id: current_user.id, product_id: params[:id]).destroy
  end

  private

  def product_params
    @product = Product.find(params[:id])
  end
end
