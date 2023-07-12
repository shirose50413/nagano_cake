class Admin::OrderItemsController < ApplicationController
  before_action :authenticate_admin!
  
  def update
    @order_item = OrderItem.find(params[:id])
    @order = Order.find(@order_item.order_id)
    @order_items = @order.order_items.all
    is_updated = true
    if @order_item.update(order_item_params)
      @order.update(state: 3) if @order_item.progress == "製作中"
      @order_items.each do |order_item|
        if order_item.progress != "製作完了"
          is_updated = false
        end
      end
      @order.update(state: 4 ) if is_updated == true
    end
    redirect_to admin_order_path(@order.id), notice: 'Successfully updated'
  end

  private

  def order_item_params
    params.require(:order_item).permit(:order_id, :item_id, :purchase_price, :amount, :progress)
  end
end
