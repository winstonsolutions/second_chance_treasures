# app/controllers/categories_controller.rb
class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @products = @category.products

    # Add search functionality
    if params[:query].present?
      search_condition = "products.title LIKE :query"
      @products = @products.where(search_condition, query: "%#{params[:query]}%")
    end

    @products = @products.page(params[:page]).per(12)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Category not found'
  end
end