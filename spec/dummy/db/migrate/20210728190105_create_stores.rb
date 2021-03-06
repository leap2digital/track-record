# frozen_string_literal: true

class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.belongs_to :owner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
