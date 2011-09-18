require 'sinatra/base'
require 'digest/md5'
require 'haml'

class CsiExample < Sinatra::Base

  set :haml, :format => :html5

  get '/screen.css' do
    never_expire!
    sass :screen
  end

  get '/include.js' do
    never_expire!
    content_type 'application/javascript', :charset => 'utf-8'
    File.read(File.expand_path('../../lib/include.js', __FILE__))
  end

  get '/' do
    never_expire!
    haml :index
  end

  get '/unicorns' do
    never_expire!
    haml :unicorns
  end

  get '/includes/:include' do |name|
    sleep 5 # feel the pain

    content = js_escape(haml(:"includes/#{name}"))
    body = <<-JS
      $.include("#{request.path}", "#{content}")
    JS

    never_expire!
    content_type 'application/javascript', :charset => 'utf-8'
    etag(Digest::MD5.hexdigest(body))
    body
  end

  def never_expire!
    expires (Time.now + 60*60*24*356).httpdate, :public, :max_age => 9999999
  end

  private

  helpers do

    # Synchronous Client Side Include
    def csi path
      acsi path
      haml_tag :script, :src => path, :type => 'text/javascript'
    end

    # Asynchronous Client Side Include
    def acsi path
      haml_tag :div, :data => {:replace_with => path}, :style => 'display:none;'
    end

    def js_escape js
      js.gsub(/(\\|<\/|\r\n|[\n\r"'])/) {|match| JS_ESCAPE_MAP[match] }
    end

    JS_ESCAPE_MAP = {
      '\\'    => '\\\\',
      '</'    => '<\/',
      "\r\n"  => '\n',
      "\n"    => '\n',
      "\r"    => '\n',
      '"'     => '\\"',
      "'"     => "\\'"
    }

  end

end
