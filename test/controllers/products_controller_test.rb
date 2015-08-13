require 'test_helper'

class ProductsControllerTest < ActionController::TestCase

  def setup
    @product = products(:one)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Product.count' do
      post :create,  product: { title: "book",
                                description: "interesting",
                                image_url: "book.jpg",
                                price: 30 }
    end
    assert_redirected_to log_in_url
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @product
    assert_redirected_to log_in_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Product.count' do
      delete :destroy, id: @product
    end
    assert_redirected_to log_in_url
  end

  test "should redirect destroy for wrong product" do
    log_in_as(users(:one))
    product = products(:two)
    assert_no_difference 'Product.count' do
      delete :destroy, id: product
    end
    assert_redirected_to root_url
  end

end
