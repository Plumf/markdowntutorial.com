require 'sinatra/base'
require 'sinatra/assetpack'
require 'redcarpet'
require 'sass'

class MarkdownTutorial < Sinatra::Base
  set :root, File.dirname(__FILE__)
  register Sinatra::AssetPack

  # "Thin is a supremely better performing web server so do please use it!"
  set :server, %w[thin webrick]

  assets {
    css :application, [
      '/css/site.css'
    ]

    css_compression :sass
  }

  # trim trailing slashes
  before do
    request.path_info.sub! %r{/$}, ''
  end

  not_found do
    markdown :notfound
  end


  # for all markdown files, keep using layout.erb
  set :markdown, :layout_engine => :erb, :layout => :layout

  get "/" do
    markdown :index
  end

  get '/lesson/:number' do  
    erb :"lesson#{params[:number]}", :locals => {:number => params[:number]}
  end  

  helpers do
    def title(number = nil)
      title = "Markdown Tutorial"
      # helper for formatting your title string
      if number
        title + " | Lesson #{number}"
      else
        title
      end
    end
  end
end