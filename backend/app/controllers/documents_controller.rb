require 'open-uri'
require 'nokogiri'
require 'net/http'
require 'json'

class DocumentsController < ApplicationController
  def index
    documents = Document.all.select(:id, :url)
    render json: documents
  end

  def create
    urls = params[:document][:url]
    urls.each do |url|
      content = fetch_content_from_url(url)
      embedding = generate_embedding(content)

      Document.create!(url: url, content: content, embedding: embedding)
    end
    render json: { success: true }, status: :created
  rescue => e
    Rails.logger.error("Error creating document: #{e.message}")
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def fetch_content_from_url(url)
    begin
      html = URI.open(url)
      doc = Nokogiri::HTML(html)
      content = doc.css('body').text.strip
      content
    rescue => e
      Rails.logger.error("Error fetching content from URL #{url}: #{e.message}")
      "Failed to fetch content"
    end
  end


    def generate_embedding(content)
    uri = URI('https://api.openai.com/v1/embeddings')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri, {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}"
    })

    request.body = {
      model: 'text-embedding-ada-002',
      input: content
    }.to_json

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      embedding_data = JSON.parse(response.body)['data'][0]['embedding']
      if embedding_data.size == 1536  # エンベディングの次元数を確認
        embedding_data
      else
        Rails.logger.error("Embedding has incorrect dimensions: #{embedding_data.size}")
        raise "Invalid embedding dimensions"
      end
    else
      error_message = JSON.parse(response.body)['error']['message']
      Rails.logger.error("Error generating embedding: #{error_message}")
      raise "OpenAI API error: #{error_message}"
    end
  end
end
