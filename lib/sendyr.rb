require "faraday"
require "sendyr/version"
require "sendyr/client"

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
