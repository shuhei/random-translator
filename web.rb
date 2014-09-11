require 'sinatra'
require 'dotenv'
Dotenv.load
require './translator'

APP_KEY = ENV['APP_KEY']

get '/' do
  translator = RandomTranslator.new(APP_KEY)
  text = params[:text] || 'こんにちは、世界！'
  from = params[:from] || 'ja'
  translator.translate(text, from)
end
