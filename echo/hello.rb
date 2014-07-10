require 'rack'
require 'grape'

module TestApp
  # Simple API Implement
  class API < Grape::API
    format :json

    get '/' do
      Time.now
    end

    get '/ping' do
      { pong: Time.now }
    end

    post '/echo' do
      { echo: params[:data], time: Time.now }
    end
  end
end
