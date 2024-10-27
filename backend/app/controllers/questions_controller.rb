require 'pgvector'
require 'faraday'

class QuestionsController < ApplicationController
  def create
    question = params[:question]
    embedding = generate_embedding(question)

    similar_documents = Document.search_by_embedding(embedding)

    render json: { documents: similar_documents }
  end

  private

  def generate_embedding(text)
    openai_api_key = ENV['OPENAI_API_KEY']
    response = Faraday.post(
      'https://api.openai.com/v1/embeddings',
      { model: 'text-embedding-ada-002', input: text }.to_json,
      { "Content-Type": "application/json", "Authorization": "Bearer #{openai_api_key}" }
    )

    if response.success?
      embedding_data = JSON.parse(response.body)
      embedding = embedding_data['data'].first['embedding']
      Pgvector::Vector.new(embedding)
    else
      Rails.logger.error("OpenAI API Error: #{response.body}")
      nil
    end
  rescue Faraday::Error => e
    Rails.logger.error("Faraday Error: #{e.message}")
    nil
  end
end
