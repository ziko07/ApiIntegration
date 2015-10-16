class WelcomeController < ApplicationController

  protect_from_forgery except: :un_sub
  def index
  end

  def devise

  end

  def facebook

  end

  def gmail

  end

  def twitter

  end

  def dashboard

  end

  def facebook_share

  end

  def gmail_share

  end

  def twitter_share

  end

  def home_page
  end

  def un_sub
    item = ''
  logger.info "parameters: #{params.inspect}"
  Rails.logger.info "parameters: #{params.inspect}"
    puts "parameters: #{params.inspect}"
  params.each do |key,value|
    item = item << value
    puts(item)
  end
    content = Content.new(:content => item)
    if request.post?
         content.save
       end
  @content = Content.all

  end

  def opengraph
    render :layout=> 'opengraph_protocol'
  end
end
