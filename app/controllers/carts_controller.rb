class CartsController < ApplicationController
  def show
    # 这里可以添加购物车逻辑
    @cart_items = [] # 暂时为空
  end
end 