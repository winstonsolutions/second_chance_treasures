class AllowNullUserIdInOrders < ActiveRecord::Migration[7.2]
  def up
    change_column_null :orders, :user_id, true
  end

  def down
    change_column_null :orders, :user_id, false
  end
end
