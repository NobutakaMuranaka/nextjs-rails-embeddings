class AddIndexToDocumentsEmbedding < ActiveRecord::Migration[7.0]
  def change
    add_index :documents, :embedding, using: :ivfflat, opclass: :vector_l2_ops
  end
end
