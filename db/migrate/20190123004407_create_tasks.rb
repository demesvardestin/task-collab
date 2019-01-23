class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :content, default: ''
      t.boolean :done, default: false
      t.integer :priority, default: 3
      t.integer :user_id
      
      t.timestamps
    end
  end
end
