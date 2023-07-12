class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  
  def show
    @order = Order.find(params[:id])
    @order_items = @order.order_items.all
    @total = @order_items.inject(0) { |sum, order_item| sum + order_item.subtotal }
  end

  def update
    @order = Order.find(params[:id])
    @order_items = OrderItem.where(order_id: params[:id])
    if @order.update(order_params)
      @order_items.update_all(progress: 2) if @order.state == "入金確認"
    end
    redirect_to admin_order_path(@order.id), notice: 'Successfully updated'
  end

  private

  def order_params
    params.require(:order).permit(:customer_id, :postage, :payment, :payment_method, :postal_code, :address, :name, :state)
  end

end
