class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :kind
      t.boolean :weekly_recurring

      t.timestamps
    end
  end
end
