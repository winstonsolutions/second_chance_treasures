class CartsController < ApplicationController
  # 添加商品到购物车的方法
  def add
    # 从参数中获取商品ID
    @product = Product.find(params[:id])
    
    # 从表单中获取数量，如果没有则默认为1
    quantity = params[:quantity].to_i || 1
    
    # 初始化session中的购物车，如果不存在
    session[:cart] ||= {}
    
    # 如果购物车中已有此商品，则增加数量，否则添加新商品
    if session[:cart][@product.id.to_s]
      session[:cart][@product.id.to_s] += quantity
    else
      session[:cart][@product.id.to_s] = quantity
    end
    
    # 跳转回商品页面并显示成功消息
    redirect_to @product, notice: "#{@product.name} 已添加到购物车"
  end
  
  # 查看购物车的方法
  def show
    # 这里可以添加购物车逻辑
    @cart_items = [] # 暂时为空
  end
  
  # 清空购物车的方法
  def clear
    # 清空session中的购物车
    session[:cart] = {}
    redirect_to root_path, notice: "购物车已清空"
  end
end 