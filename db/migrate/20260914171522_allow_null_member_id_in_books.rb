class AllowNullMemberIdInBooks < ActiveRecord::Migration[8.1]
  def change
    change_column_null :books, :member_id, true
  end
end