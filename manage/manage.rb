require 'rack'
require 'grape'
require 'faraday'
require 'faraday_middleware'
require 'docker'

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

    get '/entry' do
      case RUBY_PLATFORM
      when /darwin/i
        res = `ifconfig en0`
        res =~ /inet (\d+\.\d+\.\d+\.\d+)/
      else
        res = `ifconfig eth0`
        res =~ /inet addr:(\d+\.\d+\.\d+\.\d+)/
      end
      {
        entry: Regexp.last_match(1),
        platform: RUBY_PLATFORM
      }
    end

    get '/ping2' do
      {
        pong: Time.now,
        myname: Socket.gethostname
      }
    end

    get '/dockerinfo' do
      Docker.url = ENV['DOCKER_HOST']
      # TODO: create
      {
        containers:  Docker::Container.all
      }
    end

    get '/pping2' do
      env = ENV['ECHOENV_PORT_9292_TCP_ADDR']
      conn = Faraday::Connection.new(url: "http://#{env}:9292") do |builder|
        builder.use Faraday::Adapter::NetHttp
        builder.response :json
      end
      response = conn.get do |req|
        req.url '/ping2'
      end

      {
        res: response.body,
        try: "http://#{env}:9292",
        path: "http://#{env}:9292/ping2"
      }
    end
  end
end
