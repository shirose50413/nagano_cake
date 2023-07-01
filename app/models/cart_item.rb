class CartItem < ApplicationRecord
  def subtotal
    (item.add_tax_price * amount).round
  end
  
  belongs_to :customer
  belongs_to :item
end
