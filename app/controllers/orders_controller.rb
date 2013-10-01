class OrdersController < ApplicationController
  http_basic_authenticate_with name: "allinall", password: "twcollins", only: [:display_all, :destroy_all]

  def new
    @order = Order.new
    @items = Item.where(available: true).order('price DESC')
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.new params.require(:order).permit(:name)

    @items = Item.find(params[:items])
    @order.items = @items
    if @order.save
      flash[:auth] = @order.id
    end

    redirect_to @order
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    redirect_to new_order_path
  end

  def display_all
    @orders = Order.all
  end


  def destroy_all
    @orders = Order.all
    @orders.each do |order|
      order.destroy
    end

    @items = Item.all

    @items.each do |item|
      item.update_attributes(available: false)
    end

    flash[:notice] = 'All orders have been removed! Select the items below that you would like to be available on the next day'

    redirect_to items_path
  end
end
