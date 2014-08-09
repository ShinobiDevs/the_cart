require 'spec_helper'
require 'fixtures/shopper'
require 'fixtures/product'

describe TheCart::Shopper do

  before(:all) do
    TheCart.configure do |c|
      c.redis = Redis.new
    end

    @shopper = Shopper.new(2)
    @shopper.clear_cart!
  end

  it "should have an empty cart" do
    @shopper.cart.should eq([])
  end

  it "should have 0 items" do
    @shopper.cart_count.should eq(0)
  end


  describe "adding an item" do
    before(:all) do
      @shopper.clear_cart!
      @product = Product.new(1, "Computer", 500)
      @product_not_buying = Product.new(6, "Doll", 25)
      @product.save
    end

    it "should add an item" do
      @shopper.add_item_to_cart(@product)
      @shopper.cart_count.should eq(1)
      @shopper.cart.first.should eq({"id"=>"1", "name"=>"Computer", "price"=>"500", "class"=>"Product", "quantity" => 1})
    end

    it "Should return true if item in cart" do
      @shopper.item_in_cart?(@product).should eq(true)
    end

    it "Should return false if item not in cart" do
      @shopper.item_in_cart?(@product_not_buying).should eq(false)
    end

    it "Should remove an item" do
      @shopper.remove_item_from_cart(@product)
      @shopper.cart.count.should eq(0)
    end
  end

  describe "should return cart total" do
    before(:all) do
      @shopper.clear_cart!
      @product = Product.new(1, "Computer", 500)
      @product_expensive = Product.new(2, "Apple Computer", 1500)

      @product_expensive.save
      @product.save
    end

    it "should return 0 for empty cart" do
      @shopper.cart_total.should eq(0)
    end

    it "should return combined prices for products in cart" do
      @shopper.add_item_to_cart(@product)
      @shopper.add_item_to_cart(@product_expensive)

      @shopper.cart_count.should eq(2)
      @shopper.cart_total.should eq(2000.0)
    end

    it "should calculate quantity in total price" do
      @shopper.clear_cart!

      @shopper.add_item_to_cart(@product)
      @shopper.add_item_to_cart(@product)
      @shopper.add_item_to_cart(@product_expensive)

      @shopper.cart_count.should eq(3)
      @shopper.cart_total.should eq(2500.0)
    end
  end
end