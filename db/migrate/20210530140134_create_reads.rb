class CreateReads < ActiveRecord::Migration[6.1]
  def change
    create_table :reads do |t|
      t.references :user, foreign_key: true,null: false
      t.references :message, foreign_key: true,null: false
      t.references :room,foreign_key: true,null: false
      t.boolean    :already_read, default: false
      t.timestamps
    end
  end
end
