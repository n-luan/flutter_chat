class CreateUserRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :user_rooms do |t|
      t.references :user
      t.datetime :read_at

      t.timestamps
    end
  end
end
