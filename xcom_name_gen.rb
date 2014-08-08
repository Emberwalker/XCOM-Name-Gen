require 'sinatra/base'
require 'sinatra/reloader'
require 'haml'
require_relative 'lib/generators'

class XCOMNameGen < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload './lib/*'
  end

  # TODO: Stuff
  get '/' do
    haml :index
  end

  get '/classic' do
    content_type 'text/plain'
    Generators::classic(params[:names])
  end

  get '/modern' do
    content_type 'text/plain'
    begin
      Generators::modern(params[:firsts_m], params[:firsts_f], params[:seconds], params[:mixeds_m], params[:mixeds_f])
    rescue Exception => ex
      halt 400, ex.message
    end
  end

  # Start manually if invoked direct.
  run! if app_file == $0
end