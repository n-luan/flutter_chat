class CreateDeviceTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :device_tokens do |t|
      t.references :user
      t.string :token

      t.timestamps
    end
  end
end
