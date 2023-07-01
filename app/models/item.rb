class Item < ApplicationRecord
  has_one_attached :image

  enum status:{attack: 0,spells:1}

  def add_tax_price
    (price * 1.10).round
  end
  
  has_many :cart_items, dependent: :destroy
  
end
