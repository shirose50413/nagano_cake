class OrderItem < ApplicationRecord
  def subtotal
    (item.add_tax_price * amount).round
  end
  belongs_to :order, dependent: :destroy
  belongs_to :item, dependent: :destroy
end
