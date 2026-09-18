class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.integer :year, null: false
      t.string :isbn, null: false
      t.references :member, foreign_key: true

      t.timestamps
    end
  end
end
