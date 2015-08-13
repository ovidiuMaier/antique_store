require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @product = @user.products.build(title: "Bike", description: "Red",
                           image_url: "bike.jpg", price: 50)
  end

  test "should be valid" do
    assert @product.valid?
  end

  test "user id should be present" do
    @product.user_id = nil
    assert_not @product.valid?
  end

  test "title should be present" do
    @product.title = "    "
    assert_not @product.valid?
  end

  test "description should be present" do
    @product.description = "    "
    assert_not @product.valid?
  end

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
  end

  test "product price must be positive" do
    @product.price = -1
    assert @product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      @product.errors[:price]

    @product.price = 0
    assert @product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      @product.errors[:price]

    @product.price = 2
    assert @product.valid?
  end

  test "order should be most recent first" do
    assert_equal products(:one), Product.first
  end

end
