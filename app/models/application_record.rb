class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def previous
    Product.where("id < ?",self.id).order("id DESC").first
  end

  def next
    Product.where("id > ?", self.id).order("id ASC").first
  end
end
