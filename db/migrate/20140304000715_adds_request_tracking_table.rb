class AddsRequestTrackingTable < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :requests
      t.string :result

      t.timestamps
    end
  end
end
