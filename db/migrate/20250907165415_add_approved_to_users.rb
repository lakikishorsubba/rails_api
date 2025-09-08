class AddApprovedToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :approved, :boolean, default: false, null: false
  end
end
