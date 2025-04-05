class ProductsController < ApplicationController
  # Index action - displays a list of all products
  def index
    # Start with base query
    @products = Product.all
    @categories = Category.all  # For the category dropdown

    # Build search query
    if params[:query].present?
      search_condition = "products.title LIKE :query"
      @products = @products.where(search_condition, query: "%#{params[:query]}%")
    end

    # Filter by category if selected
    if params[:category_id].present? && params[:category_id] != ""
      @products = @products.joins(:categories).where(categories: { id: params[:category_id] })
    end

    # Apply existing filters
    case params[:filter]
    when 'on_sale'
      @products = @products.where(on_sale: true)
    when 'new'
      @products = @products.where('products.created_at >= ?', 3.days.ago)
    end

    # Add ordering and pagination
    @products = @products.order('products.created_at DESC').page(params[:page]).per(12)
  end

  # Show action - displays a specific product based on ID
  def show
    @product = Product.find(params[:id])
    # Get primary category for breadcrumb navigation
    @primary_category = @product.categories.first if @product.categories.any?
  end

  # New action - displays form for creating a new product
  def new
    @product = Product.new
  end

  # Create action - handles the form submission from new action
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      # 添加调试信息
      Rails.logger.debug "Product creation failed: #{@product.errors.full_messages}"
      flash.now[:alert] = @product.errors.full_messages.join(", ")
      render :new
    end
  end

  # Edit action - displays form for editing a product
  def edit
    @product = Product.find(params[:id])
  end

  # Update action - handles the form submission from edit action
  def update
    @product = Product.find(params[:id])

    if @product.update(product_params)
      # Redirect to the product page with a success message
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      # Re-render the edit form if there are errors
      render :edit
    end
  end

  # Destroy action - removes a product from the database
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    # Redirect to the products index with a success message
    redirect_to products_path, notice: 'Product was successfully destroyed.'
  end

  private
    # Strong parameters - defines which parameters are allowed
    # This helps prevent mass assignment vulnerabilities
    def product_params
      params.require(:product).permit(
        :title,
        :description,
        :price,
        :condition,
        :quantity,
        :sku,
        :is_featured,
        :image,
        images: [],
        category_ids: []
      )
    end
end