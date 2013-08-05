require "uri"
require "net/http"

module NetHelper
  def self.postRequest(url, params)
    return Net::HTTP.post_form(URI.parse(url), params)
  end

  def self.getRequest(url_in, params)
  	url = URI.parse(url_in)
    req = Net::HTTP.Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)}
    return res.body
  end
end
