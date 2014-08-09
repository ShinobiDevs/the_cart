module TheCart
  module Item

    def self.included(base)
      base.class_eval do
        
        include InstanceMethods
        extend ClassMethods

        after_save :update_cart_details
      end
    end

    module ClassMethods

      # Mark the list of fields to track in redis for fast access.
      def cartify_item(options = {})
        
        configuration = {
          track: [:id],
          price_field: :price
        }.merge(options)

        configuration[:track] << :id 
        @price_column = configuration[:price_field]

        self.cart_fields = configuration[:track]

      end

      def price_column
        @price_column ||= :price
      end
      # Set trackable fields
      def cart_fields=(new_field_list)
        @cart_fields = new_field_list
      end

      # Retrieve trackable fields
      def cart_fields
        @cart_fields ||= []
      end

    end

    module InstanceMethods

      def update_cart_details
        TheCart.redis.multi do
          attr_hash = {}

          self.class.cart_fields.each do |field|
            attr_hash[field] = self.send(field)
          end

          attr_hash["price"] = self.send(self.class.price_column)
          attr_hash["class"] = self.class.name
          
          TheCart.redis.hmset cart_item_id_key, *attr_hash.to_a
        end
        true
      end


      protected

      def cart_item_id_key
        "the_cart:#{self.id}:item_details"
      end

    end
  end
end