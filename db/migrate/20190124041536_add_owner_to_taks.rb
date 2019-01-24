class AddOwnerToTaks < ActiveRecord::Migration[5.2]
  def change
    create_table :task_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :task, index: true
    end
  end
end
