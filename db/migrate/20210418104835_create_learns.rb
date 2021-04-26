class CreateLearns < ActiveRecord::Migration[6.1]
  def change
    create_table :learns do |t|
      t.string  :title,null: false
      t.string  :content,null: false
      t.string  :subject,null: false
      t.integer :time , null: false
      t.references :user,null:false,foreign_key:true
      t.references :draft_learn,null:false,foreign_key:true
      t.timestamps
    end
  end
end
