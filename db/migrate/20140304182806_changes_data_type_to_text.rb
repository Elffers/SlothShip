class ChangesDataTypeToText < ActiveRecord::Migration
  def change
    remove_column :requests, :request 
    add_column :requests, :request, :text
    remove_column :requests, :result 
    add_column :requests, :result, :text
  end
end
