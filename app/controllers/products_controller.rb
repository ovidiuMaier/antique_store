class ProductsController < ApplicationController
  before_action :require_login, only: [:create, :destroy, :edit]
  before_action :correct_user, only: [:destroy, :edit]

  def index
    @products = Product.all
  end

  def show
  #  if Product.exists?(:id => params[:id])
      @product = Product.find(params[:id])
#    else
#      flash[:danger] = "Product doesn't exist!"
#      redirect_to products_url
#    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = current_user.products.build(product_params)
    respond_to do |format|
      if @product.save
        format.html { flash[:success] = "Product added!"
                      redirect_to @product }
        format.json { render :show, status: :created, location: @product }
      else
        @feed_items = []
        format.html { flash[:warning] = "Product create failed"
                      render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(product_params)
        format.html { flash[:success] = "Product updated"
                      redirect_to @product }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { flash[:warning] = "Product update failed"
                      render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    Product.find(params[:id]).destroy
    respond_to do |format|
      format.html { flash[:success] = "Product deleted"
                    redirect_back_or_to products_url }
      format.json { head :no_content }
    end
  end

  private

    def product_params
      params.require(:product).permit(:title, :description, :image_url, :price)
    end

    def correct_user
      @product = current_user.products.find_by(id: params[:id])
      redirect_to root_url if @product.nil?
    end

end
