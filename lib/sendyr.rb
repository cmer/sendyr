require "faraday"
require "require_all"
require_all File.dirname(__FILE__) + "/sendyr"

module Sendyr
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :url, :api_key

    def initialize
    end
  end
end
