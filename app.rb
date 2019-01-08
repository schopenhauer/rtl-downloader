require 'sinatra'
require 'sinatra/reloader' if development?
require 'better_errors'
require 'net/http'
require 'uri'
require 'base64'
require 'dotenv'
Dotenv.load

REGEX_LINKS = /(?:https:\\\/\\\/)[A-Z0-9a-z\.\\\/_-]*(?:\.mp4)/
DEFAULT_URL = ENV['DEFAULT_URL'] || 'http://tele.rtl.lu/emissiounen/de-journal/3147643.html'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

configure { set :server, :puma }

set :public_folder, 'public'

get '/' do
  erb :home
end

post '/' do
  url = params[:url]
  quality = params[:quality]
  html = Net::HTTP.get(URI.parse(url))
  videos = html.scan(REGEX_LINKS).select! { |v| v.include? '480p' }
  videos.map { |v| v.gsub!('\/', '/') }
  videos.map { |v| v.gsub!('480p', quality) }
  links = videos.map { |v| Base64.urlsafe_encode64(v) }
  erb :videos, locals: {
    videos: videos,
    links: links
  }
end

get '/dl/:url' do
  url = params[:url]
  uri = URI.parse(Base64.urlsafe_decode64(url))
  filename = File.basename(uri.path)

  header = Net::HTTP.start(uri.host, uri.port) do |f|
    f.head(uri.request_uri)
  end

  headers['Content-Type'] = header['Content-Type']
  headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""

  stream do |out|
    Net::HTTP.get_response(uri) do |f|
      f.read_body { |c| out << c }
    end
  end
end

get '/robots.txt' do
  status 200
  body "User-agent: *\nDisallow: /"
end

get '/*' do
  redirect '/'
end

error do
  redirect '/'
end
