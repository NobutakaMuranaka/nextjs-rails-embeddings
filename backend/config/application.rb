require_relative "boot"

require 'rails/all'
require 'pgvector'
require 'dotenv/load' if Rails.env.development? || Rails.env.test?

Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    config.load_defaults 7.2
    config.api_only = true

    config.autoload_paths += %W(#{config.root}/app/models)
    config.autoload_paths << Rails.root.join('lib')

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'localhost:3001'
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head]
      end
    end
  end
end
