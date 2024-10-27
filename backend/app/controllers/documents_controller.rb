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
    openai_api_key = ENV['OPENAI_API_KEY']
    uri = URI('https://api.openai.com/v1/embeddings')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri, {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{openai_api_key}"
    })

    request.body = {
      model: 'text-embedding-ada-002',
      input: content
    }.to_json

    response = http.request(request)
    if response.code == '200'
      embedding = JSON.parse(response.body)['data'][0]['embedding']
      embedding
    else
      Rails.logger.error("Error generating embedding: #{response.body}")
      []
    end
  end
end
