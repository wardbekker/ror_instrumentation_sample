class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end

    
    uri = URI.parse("https://google.com/")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    @data = http.get(uri.request_uri)    

    uri = URI.parse("https://finastra.com/")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    @data = http.get(uri.request_uri)    

    uri = URI.parse("https://grafana.com/")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    @data = http.get(uri.request_uri)    
    

  end
  
  def help
    raise "sample exception"
  end

  def about
  end

  def contact
  end
end
