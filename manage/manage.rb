require 'rack'
require 'grape'
require 'faraday'
require 'faraday_middleware'
require 'docker'

# For Test App
module TestApp
  WEBAPI_IMG_NAME = 'kato/echo'
  # Simple API Implement
  class API < Grape::API
    format :json

    helpers do
      def call_web_api
        conn = Faraday::Connection.new(url: "http://#{@ip}:9292") do |builder|
          builder.use Faraday::Adapter::NetHttp
          builder.response :json
        end
        response = conn.get do |req|
          req.url '/ping2'
        end
        response.body
      end

      def find_waiting
        Docker::Container.all(all: true).delete_if do | i |
          i.info['Image'] !~ /#{WEBAPI_IMG_NAME}/ ||
          /Exited/ !~ i.info['Status']
        end
      end
    end

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
        containers:  Docker.version
      }
    end

    get '/pping2' do
      @ip = ENV['ECHOENV_PORT_9292_TCP_ADDR']
      {
        res: call_web_api
      }
    end

    get '/auto' do
      Docker.url = ENV['DOCKER_HOST']
      docks = find_waiting
      if docks.length == 0
        d = Docker::Container.create('Image' => 'kato/echo')
      else
        # restart
        d = docks.first
      end
      d.start
      sleep(1)
      @ip = d.json['NetworkSettings']['IPAddress']
      out = call_web_api
      d.stop
      {
        res: out,
        status: d.json
      }
    end

    get '/find' do
      Docker.url = ENV['DOCKER_HOST']
      {
        res: find_waiting
      }
    end

    get '/create' do
      v = Docker::Container.create('Image' => 'kato/echo')
      v.start
      @ip = v.json['NetworkSettings']['IPAddress']
      sleep(1)
      out = call_web_api
      v.stop
      {
        res: out,
        status: v.json
      }
    end
  end
end
