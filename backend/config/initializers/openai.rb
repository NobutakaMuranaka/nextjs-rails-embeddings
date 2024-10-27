require 'httparty'

class OpenAIClient
  include HTTParty
  base_uri 'https://api.openai.com/v1'

  def initialize
    @headers = {
      "Authorization" => "Bearer #{ENV['OPENAI_API_KEY']}",
      "Content-Type" => "application/json"
    }
  end

  def create_embedding(data)
    self.class.post('/embeddings', body: data.to_json, headers: @headers)
  end
end
