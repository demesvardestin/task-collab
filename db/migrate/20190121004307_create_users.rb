class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, default: "", null: false
      t.string :password, default: "", null: false
      t.string :password_hash, default: "", null: false
      
      t.timestamps null: false
    end
  end
end
