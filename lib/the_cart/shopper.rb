module TheCart
  module Shopper

    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end

    module InstanceMethods

      def cart

        TheCart.redis.zrange(self.cart_id_key, 0, -1, {withscores: true}).map { |item| 
          item_id, quantity = item
          hash = TheCart.redis.hgetall "the_cart:#{item_id}:item_details"
          hash["quantity"] = quantity.to_i
          hash
        }
      end

      def item_in_cart?(item)
        TheCart.redis.zrank(self.cart_id_key, item.id) != nil
      end

      def add_item_to_cart(item)
        if item_in_cart?(item)
          TheCart.redis.zincrby self.cart_id_key, 1, item.id
        else
          TheCart.redis.zadd self.cart_id_key, 1, item.id
        end
        TheCart.redis.expire self.cart_id_key, self.class.cart_configuration[:expire_cart_in].to_i
      end

      def remove_item_from_cart(item)
        TheCart.redis.zrem self.cart_id_key, item.id
        TheCart.redis.expire self.cart_id_key, self.class.cart_configuration[:expire_cart_in].to_i
      end

      def cart_count
        total = 0
        TheCart.redis.zrange(self.cart_id_key, 0, -1, {withscores: true}).map { |item|
          item_id, quantity = item
          total += quantity.to_i
        }
        total
      end

      def cart_total
        total = 0
        self.cart.map {|item| total += item["price"].to_f * item["quantity"].to_i }
        total
      end

      def clear_cart!
        TheCart.redis.del self.cart_id_key
      end

      protected

      def cart_id_key
        "the_cart:#{self.id}:cart"
      end

    end

    module ClassMethods

      def cartify(options = {})
        @the_cart_configuration = {
          expire_cart_in: 24
        }.merge(options)
      end

      def cart_configuration
        @the_cart_configuration
      end
    end
  end
end
