module ApplicationHelper

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def open_graph_meta_tags(meta_hash)
    meta_text = ""
    meta_hash.each_pair do |key,value|
      meta_text << "<meta property=\"#{key}\" content=\"#{value.html_safe}\" />"
    end
    content_for :og_meta do
      meta_text.html_safe
      puts "#{meta_text}"
    end
  end

  def meta_tags(meta_hash)
    meta_text = ""
    meta_hash.each_pair do |key,value|
      meta_text << "<meta name=\"#{key}\" content=\"#{value.html_safe}\" />"
    end
    content_for :og_meta do
      meta_text.html_safe
    end
  end

end
