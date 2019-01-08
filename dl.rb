require 'optparse'
require 'open-uri'

ARGV << '-h' if ARGV.empty?
LINKS = /(?:https:\\\/\\\/)[A-Z0-9a-z\.\\\/_-]*(?:\.mp4)/

options = {
  quality: '480p',
  legacy: false
}

OptionParser.new do |opts|
  opts.banner = 'Usage: ruby dl.rb <URL> [options]'
  opts.on('-1', '--low', 'Low quality (144p)') do |v| options[:quality] = '144p' end
  opts.on('-2', '--average', 'Average quality (240p)') do |v| options[:quality] = '240p' end
  opts.on('-3', '--high', 'High quality (480p)') do |v| options[:quality] = '480p' end
  opts.on('-4', '--highest', 'Highest quality (720p)') do |v| options[:quality] = '720p' end
  opts.on('-l', '--legacy', 'Use legacy parser') do |v| options[:legacy] = true end
  opts.on_tail('-h', '--help', 'Show help message') do
    puts opts
    exit
  end
end.parse!

def fetch(str)
  URI.parse(str).read
end

def download(url)
  uri = URI.parse(url)
  filename = File.basename(uri.path)
  puts "Downloading: #{url}"
  file = fetch(url)
  open(filename, 'wb+') do |f|
    f.write(file)
  end
  puts "Saved: #{filename}"
end

def legacy(str)
  str[str.index(/httphq/) + 16, 91]
end

def unescape(str)
  str.gsub!('\/', '/')
end

ARGV.each do |page|
  html = fetch(page)
  quality = options[:quality].to_s
  puts "Parsing: #{page} (quality: #{quality})"
  if options[:legacy] == false
    videos = html.scan(LINKS).select! { |v| v.include? '480p' }
    videos.map { |v| v = unescape(v) }
    videos.map { |v| v.gsub!('480p', quality) }
    count = videos.size
    puts "Found: #{count} video" + (count > 1 ? 's' : '')
    videos.map do |url|
      download(url)
    end
  else
    puts 'Legacy parser: Yes'
    url = unescape(legacy(html))
    download(url)
  end
end
