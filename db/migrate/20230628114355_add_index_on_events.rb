class AddIndexOnEvents < ActiveRecord::Migration[7.0]
  def change
    add_index :events, [:kind, :weekly_recurring, :starts_at]
  end
end
