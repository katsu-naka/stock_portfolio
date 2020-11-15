class ProductsController < ApplicationController
  def index
  end

  def new
    @prodact = Prodact.new
  end
end
