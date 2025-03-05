class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :zipcode

      t.timestamps
    end
  end
end
