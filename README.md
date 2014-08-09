# TheCart

TheCart is an implementation of a cart that utilizes Redis's awesomeness.

## Installation

Add this line to your application's Gemfile:

    gem 'the_cart'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install the_cart

## Configuration

create an initializer in `config/initializers/the_cart.rb`:

    TheCart.configure do |c|
      #...
    end

The following options exist:

* redis: an existing Redis connection, defaults to a `Redis.new` instance.

## Usage

TheCart consists of two main actors, `Shopper` and `Item`.

### Shopper

To add shopping abilities to a class, add the following:

```ruby
  include TheCart::Shopper
```

and the `cartify` directive:

```ruby
  cartify cart_expires_in: 12
```

`cart_expires_in` lets TheCart know in how many hours the cart key in redis should be expired, defaults to 24 hours.


### Item

To allow the shopper to add items to the cart, all classes that can be added should include the following:

```ruby
  include TheCart::Item
```

and the following configuration:

```ruby
  cartify_item track: [field1, field2,...], price_field: :price
```
Those `track` fields/attributes/methods return values will be cached in Redis after everytime you save the item instance, note that
your ORM needs to implement `after_save` since TheCart utilizes those callbacks to update the cached data from Redis.

The `id` attribute will automatically be cached.

`price_field` is the name of the attribute / method that returns the item price, defaults to `:price`

## Examples

### Listing items in a cart

  @user.cart # => returns a hash of the tracked item fields currently cached, with quantity

### Adding an item
  
  @user.add_item_to_cart(@product)

### Removing an item

  @user.remove_item_from_cart(@product)

## Count items in cart
  
  @user.cart_count #=> will return the actual item count, quantity considered.

### Total Cost of items in cart

  @user.cart_total #= 3000.0

## Contributing

1. Fork it ( http://github.com/<my-github-username>/the_cart/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
