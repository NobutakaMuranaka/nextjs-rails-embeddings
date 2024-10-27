class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :url, null: false
      t.text :content, null: false
      t.timestamps
    end
  end
end
