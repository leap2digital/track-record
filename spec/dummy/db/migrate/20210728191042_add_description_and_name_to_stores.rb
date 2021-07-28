class AddDescriptionAndNameToStores < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :description, :string
    add_column :stores, :name, :string
  end
end
