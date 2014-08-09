class Shopper

  include TheCart::Shopper

  cartify cart_expires_in: 24

  attr_accessor :id

  def initialize(id)
    @id = id
  end

end
