class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_cart_item, only: [:update, :destroy]

  def index
    @cart_items = current_customer.cart_items
    @total = @cart_items.inject(0) { |sum, cart_item| sum + cart_item.subtotal }
  end

  def create
    increase_or_create(params[:cart_item][:item_id])
    redirect_to cart_items_path, notice: 'Successfully added product to your cart'
  end

  def update
    @cart_item.update(cart_item_params)
    redirect_to cart_items_path, notice: 'Successfully updated your cart'
  end

  def destroy
    @cart_item.destroy
    redirect_to cart_items_path, notice: 'Successfully deleted one cart item'
  end

  def destroy_all
    @cart_items = current_customer.cart_items
    @cart_items.destroy_all
    redirect_to cart_items_path
  end

  private

  def set_cart_item
    @cart_item = current_customer.cart_items.find(params[:id])
  end

  def increase_or_create(item_id)
    cart_item = current_customer.cart_items.find_by(item_id:)
    if cart_item
      cart_item.increment!(:amount, 1)
    else
      @cart_item = CartItem.new(cart_item_params)
      @cart_item.customer_id = current_customer.id
      unless @cart_item.save
        render "items/show"
      end
    end
  end

  def cart_item_params
    params.require(:cart_item).permit(:item_id, :customer_id, :amount)
  end
end
