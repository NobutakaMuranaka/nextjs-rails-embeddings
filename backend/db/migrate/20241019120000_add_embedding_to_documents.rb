class AddEmbeddingToDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :documents, :embedding, :vector, limit: 1536
  end
end
