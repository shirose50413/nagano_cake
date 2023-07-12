class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!
  
  def new
    @order = Order.new
    @customer = current_customer
  end

  def create
    cart_items = current_customer.cart_items.all
    @order = current_customer.orders.new(order_params)
    if @order.save
      cart_items.each do |cart|
        order_item = OrderItem.new
        order_item.item_id = cart.item_id
        order_item.order_id = @order.id
        order_item.amount = cart.amount
        order_item.purchase_price = cart.item.add_tax_price
        order_item.save
      end
      redirect_to complete_orders_path
      cart_items.destroy_all
    else
      @order = Order.new(order_params)
      render :new
    end
  end

  def check
    @order = Order.new(order_params)
    @order.postage = 800
    @cart_items = current_customer.cart_items.all
    @total = @cart_items.inject(0) { |sum, cart_item| sum + cart_item.subtotal }
    @payment = @order.postage + @total
    if params[:order][:address_number] == "1"
      @order.name = current_customer.last_name + current_customer.first_name
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
    # elsif params[:order][:address_number] == "2"
  # view で定義している address_number が"2"だったときにこの処理を実行します
      # if Address.exists?(name: params[:order][:registered])
  # registered は viwe で定義しています
        # @order.name = Address.find(params[:order][:registered]).name
        # @order.address = Address.find(params[:order][:registered]).address
      # else
        # render :new
  # 既存のデータを使っていますのでありえないですが、万が一データが足りない場合は new を render します
      # end
    elsif params[:order][:address_number] == "2"
      # address_new = current_customer.addresses.new(address_params)
      # if address_new.save # 確定前(確認画面)で save してしまうことになりますが、私の知識の限界でした
      # else
        # render :new
  # ここに渡ってくるデータはユーザーで新規追加してもらうので、入力不足の場合は new に戻します
      # end
    else
      redirect_to new_order_path
    end
  end

  def complete
  end

  def index
    @orders = current_customer.orders.all
  end

  def show
    @order = current_customer.orders.find(params[:id])
    order_items = @order.order_items.all
    @total = order_items.inject(0) { |sum, order_item| sum + order_item.subtotal }
    @payment = @order.postage + @total
  end

  private

  def order_params
    params.require(:order).permit(:postage, :payment_method, :payment, :postal_code, :address, :name)
  end

  def address_params
    params.require(:order).permit(:name, :address)
  end
end
