class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :album_id
      t.text :body
      t.float :point

      t.timestamps
    end
  end
end
