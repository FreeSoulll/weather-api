class CreateForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :forecasts do |t|
      t.float :temperature
      t.timestamp :epoch_time

      t.timestamps
    end

    add_index :forecasts, :epoch_time, unique: true
  end
end
