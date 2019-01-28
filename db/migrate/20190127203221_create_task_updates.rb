class CreateTaskUpdates < ActiveRecord::Migration[5.2]
  def change
    create_table :task_updates do |t|
      t.integer :task_id
      t.integer :user_id
      t.text :content
      
      t.timestamps
    end
  end
end
