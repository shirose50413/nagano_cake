class OrderItem < ApplicationRecord

  enum progress:{"着手不可": 1, "製作待ち":2, "製作中":3, "製作完了":4}

  def subtotal
    (item.add_tax_price * amount).round
  end

  def add_tax_price
    (price * 1.10).round
  end

  belongs_to :order, dependent: :destroy
  belongs_to :item, dependent: :destroy
end
