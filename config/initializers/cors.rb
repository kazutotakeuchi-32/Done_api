# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # origins 'example.com'
    origins "http://localhost:3001",'https://done-17941.web.app','http://192.168.100.100:3001'
    resource '*',
      headers: :any,
      expose: ['access-token', 'uid','client'],
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end

end
