require 'pgvector'

class Document < ApplicationRecord
  has_neighbors :embedding

  validates :url, presence: true
  validates :content, presence: true

  before_save :set_embedding

  private

  def set_embedding
    self.embedding = FlaskClient.embeddings(content)
  end
end
