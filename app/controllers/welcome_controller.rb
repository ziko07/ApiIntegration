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
  logger.info params.inspect
  end

  def opengraph
    render :layout=> 'opengraph_protocol'
  end
end
