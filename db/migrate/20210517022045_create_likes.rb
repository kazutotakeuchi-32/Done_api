class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :user, foreign_key: true
      t.references :learn, foreign_key: true
      t.references :draft_learn, foreign_key:true
      t.timestamps
    end
    add_index :likes, [:user_id, :draft_learn_id], unique: true
    add_index :likes, [:user_id, :learn_id], unique: true
  end
end
