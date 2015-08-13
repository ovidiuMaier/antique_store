require 'test_helper'

class ProductsEditTest < ActionDispatch::IntegrationTest

  def setup
    @product = products(:one)
  end

  test "unsuccessful edit" do
    @user = users(:one)
    log_in_as @user
    get edit_product_path(@product)
    assert_template 'products/edit'
    patch product_path(@product), product: { title: "",
                                             description: "invalid",
                                             image_url: "invalid.jpg",
                                             price: 9.99 }
    assert_not flash.empty?
    assert_template 'products/edit'
  end

  test "successful edit" do
    @user = users(:one)
    log_in_as @user
    get edit_product_path(@product)
    assert_template 'products/edit'
    title = "title"
    description = "description"
    patch product_path(@product), product: { title: title,
                                             description: description,
                                             image_url: "image.jpg",
                                             price: 9.99 }
    assert_not flash.empty?
    assert_redirected_to @product
    @product.reload
    assert_equal title, @product.title
    assert_equal description, @product.description
  end

end
