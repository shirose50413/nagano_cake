class Order < ApplicationRecord
  enum payment_method:{"銀行振込": 1, "クレジットカード":2}
  
  belongs_to :customer
  has_many :order_items, dependent: :destroy
end
