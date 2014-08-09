class Product

  attr_accessor :id, :name, :price

  def Product.after_save(method)
    @after_save_method = method
  end

  include TheCart::Item

  cartify_item track: [:id, :name]


  def initialize(id, name, price)
    @id = id
    @name = name
    @price = price
  end

  def Product.after_save_method
    @after_save_method
  end

  def save
    self.send(Product.after_save_method)
  end
end