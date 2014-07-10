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
  end
end
