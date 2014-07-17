class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.integer :user_id
      t.integer :score
      t.string :activity

      t.timestamps
    end
  end
end
