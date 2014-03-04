class ChangesRequestsToRequest < ActiveRecord::Migration
  def change
    remove_column :requests, :requests 
    add_column :requests, :request, :string
  end
end
