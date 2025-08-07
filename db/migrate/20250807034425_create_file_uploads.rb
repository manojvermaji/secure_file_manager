class CreateFileUploads < ActiveRecord::Migration[8.0]
  def change
    create_table :file_uploads do |t|
      t.string :title
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.boolean :public
      t.string :share_token

      t.timestamps
    end
  end
end
