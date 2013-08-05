require "uri"
require "net/http"

module PostHelper
  def self.postRequest(url, params)
    x = Net::HTTP.post_form(URI.parse(url), params)
    return x
  end
end
