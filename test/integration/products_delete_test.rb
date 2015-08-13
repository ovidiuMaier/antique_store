require 'test_helper'

class ProductsDeleteTest < ActionDispatch::IntegrationTest

  def setup
    @product = products(:one)
  end

  test "should destroy" do
    @user = users(:one)
    @product.user_id = @user.id
    log_in_as @user
    assert_difference 'Product.count', -1 do
      delete product_path(@product)
    end
    assert_not flash.empty?
  end

end
