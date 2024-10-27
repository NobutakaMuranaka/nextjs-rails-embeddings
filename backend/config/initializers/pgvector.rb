require 'pgvector'

Rails.application.config.after_initialize do
  ActiveRecord::Base.connection.enable_extension('vector') if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
end
