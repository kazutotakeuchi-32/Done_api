class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string     :kind ,null:false
      t.boolean    :checked,null: false,default: false
      t.references :sender,foreign_key:   { to_table: :users },optional:true
      t.references :receiver,foreign_key: { to_table: :users },optional:true
      t.integer    :message_id
      t.integer    :learn_id
      t.integer    :draft_learn_id
      t.integer    :follow_id
      t.timestamps
    end
  end
end
