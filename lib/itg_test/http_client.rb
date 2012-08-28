require 'net/http'

# Synopsis
# c = ItgTest::HTTPClient.new 'http://localhost:3000'
# c.get '/scheduled_posts/post_due' => <head></head><body>...</body>

module ItgTest; end
class ItgTest::HTTPClient
  attr_accessor :cookie
  def initialize url
    new_url = if %r|^http://.+$| =~ url || %r|^https://.+$| =~ url
                url
              else
                "http://" + url
              end
    @cookie = ""
    @uri = URI(new_url)
  end

  def session
    Net::HTTP.start(@uri.host, @uri.port, use_ssl: @uri.scheme == 'https')
  rescue Errno::ECONNREFUSED => e
    sleep(1); retry
  end

  def get path, query=''
    path = path[0...-1] if path[-1] == "/"
    path = "/#{path}" unless path[0] == "/"
    if query == ''
      _get path
    else
      _get "#{path}?#{to_query(query)}"
    end
  end

  def _get path, limit = 10
    raise ArgumentError, 'too many HTTP redirects' if limit == 0
    res = session.get(path, {'Cookie'=>@cookie})
    cookie_array = res.get_fields('set-cookie')
    @cookie = cookie_array.collect{|ea| ea[/^.*?;/]}.join if cookie_array
    final_res = handle_res res, limit
    JSON.parse final_res
  rescue JSON::ParserError
    final_res
  end

  def post path, params
    res = session.post path, to_query(params), {'Cookie'=>@cookie}
    handle_res res
  end

  def to_query params, namespace=nil
    if params.is_a?(Hash)
      params.collect do |key, value|
        to_query(value, namespace ? "#{namespace}[#{key}]" : key)
      end.sort * '&'
    elsif params.is_a?(Array)
      prefix = "#{namespace}[]"
      params.collect { |value| to_query(value, prefix) }.join '&'
    else
      "#{CGI.escape(namespace.to_s)}=#{CGI.escape(params.to_s)}"
    end
  end

  def handle_res res, limit=10
    case res
    when Net::HTTPRedirection
      location = res['location']
      warn "redirected to #{location}"
      if %r|^http://.+$| =~ location || %r|^https://.+$| =~ location
        @uri = URI(location)
        _get(@uri.path, limit - 1)
      else
        _get(location, limit - 1)
      end
    when Net::HTTPSuccess
      res.body
    else
      res.value
    end
  end
end
