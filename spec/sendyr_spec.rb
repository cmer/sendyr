require 'spec_helper'

describe Sendyr do
	before do
		@base_url = 'http://localhost'
		Sendyr.configure do |c|
			c.url = @base_url
		end
	end

	describe ".configure" do
		it "configures itself properly" do
			url = 'http://example.org'
			api_key = 'abcd'

			Sendyr.configure do |c|
				c.url = url
				c.api_key = api_key
			end

			Sendyr.configuration.url.should == url
			Sendyr.configuration.api_key.should == api_key
		end
	end
end
